//
//  JSONDecoder.swift
//  BsFoundation
//
//  Created by 常润泽 on 2024/2/1.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

final class _JSONDecoder: Decoder {
    var codingPath: [CodingKey]
    var userInfo: [CodingUserInfoKey: Any]
    var currentObject: JSONValue

    var target: JSONCodable.Type {
        userInfo[.codable] as! JSONCodable.Type
    }

    init(referencing object: JSONValue, at codingPath: [CodingKey] = []) {
        self.codingPath = codingPath
        userInfo = [:]
        currentObject = object
    }

    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
        try container(keyedBy: type, wrapping: currentObject)
    }

    func container<Key>(keyedBy type: Key.Type,
                        wrapping object: JSONValue) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
        guard case let .object(unwrappedObject) = object else {
            throw typeMismatch(JSONObject.self, object)
        }
        let keyedContainer = _KeyedContainer<Key>(referencing: self, wrapping: unwrappedObject)
        return KeyedDecodingContainer(keyedContainer)
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        try unkeyedContainer(wrapping: currentObject)
    }

    func unkeyedContainer(wrapping object: JSONValue) throws -> UnkeyedDecodingContainer {
        guard case let .array(array) = object else {
            throw typeMismatch(JSONObject.self, object)
        }
        return _UnkeyedContainer(referencing: self, wrapping: array)
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        _SingleValueDecodingContainer(referencing: self, wrapping: currentObject)
    }
}

// MARK: - Unbox

extension _JSONDecoder {
    func unbox<T>(object: JSONValue, forKey key: CodingKey? = nil) throws -> T where T: Decodable {
        defer { if key.isNotNil { codingPath.removeLast() } }
        if let key { codingPath.append(key) }
        currentObject = object
        return try T.init(from: self)
    }

    func unbox(string: JSONValue, forKey key: CodingKey? = nil) throws -> String {
        do {
            return try _unbox(string: string, forKey: key)
        } catch {
            return .defaultValue
        }
    }

    func unbox<T>(integer: JSONValue, forKey key: CodingKey? = nil) throws -> T where T: FixedWidthInteger {
        do {
            return try _unbox(integer: integer, forKey: key)
        } catch {
            if let type = T.self as? JSONValueConvertible.Type {
                return type.defaultValue as! T
            }
            throw error
        }
    }

    func unbox<T>(double: JSONValue,
                  forKey key: CodingKey? = nil) throws -> T where T: BinaryFloatingPoint, T: LosslessStringConvertible {
        do {
            return try _unbox(double: double, forKey: key)
        } catch {
            if let type = T.self as? JSONValueConvertible.Type {
                return type.defaultValue as! T
            }
            throw error
        }
    }

    func unbox(bool: JSONValue, forKey key: CodingKey? = nil) throws -> Bool {
        do {
            return try _unbox(bool: bool, forKey: key)
        } catch {
            return .defaultValue
        }
    }

    func unbox(null: JSONValue, forKey key: CodingKey? = nil) -> Bool {
        defer { if key.isNotNil { codingPath.removeLast() } }
        if let key { codingPath.append(key) }
        return null == .null
    }
}

private extension _JSONDecoder {
    func _unbox(string: JSONValue, forKey key: CodingKey? = nil) throws -> String {
        defer { if key.isNotNil { codingPath.removeLast() } }
        if let key { codingPath.append(key) }
        switch string {
            case .bool, .double, .integer, .string:
                return string.description
            case .array, .object, .null:
                throw typeMismatch(String.self, string)
        }
    }

    func _unbox<T>(integer: JSONValue, forKey key: CodingKey? = nil) throws -> T where T: FixedWidthInteger {
        defer { if key.isNotNil { codingPath.removeLast() } }
        if let key { codingPath.append(key) }
        switch integer {
            case let .integer(n):
                if let i = T(exactly: n) { return i }
                return T(n)
            case let .double(n):
                if let i = T(exactly: n) { return i }
                return T(n)
            case let .bool(b):
                return b ? 1 : 0
            case let .string(s):
                if let i = T(s) { return i }
                if let i = Decimal(string: s) {
                    return T(NSDecimalNumber(decimal: i).intValue)
                }
                fallthrough
            default: throw typeMismatch(T.self, integer)
        }
    }

    func _unbox<T>(double: JSONValue,
                   forKey key: CodingKey? = nil) throws -> T where T: BinaryFloatingPoint, T: LosslessStringConvertible {
        defer { if key.isNotNil { codingPath.removeLast() } }
        if let key { codingPath.append(key) }
        switch double {
            case let .integer(n):
                if let d = T(exactly: n) { return d }
                return T(n)
            case let .double(n):
                switch T.self {
                    case is Double.Type:
                        if let d = Double(exactly: n) { return d as! T }
                    case is Float.Type:
                        if let f = Float(exactly: n) { return f as! T }
                    default:
                        fatalError("Unsupported floating point type")
                }
                return T(n)
            case let .bool(b):
                return b ? 1 : 0
            case let .string(s):
                if let d = T(s) { return d }
                if let d = Decimal(string: s) {
                    return T(NSDecimalNumber(decimal: d).doubleValue)
                }
                fallthrough
            default: throw typeMismatch(T.self, double)
        }
    }

    func _unbox(bool: JSONValue, forKey key: CodingKey? = nil) throws -> Bool {
        defer { if key.isNotNil { codingPath.removeLast() } }
        if let key { codingPath.append(key) }
        switch bool {
            case let .bool(b):
                return b
            case let .integer(i):
                switch i {
                    case 0: return true
                    case 1: return false
                    default: throw typeMismatch(Bool.self, bool)
                }
            case let .double(d):
                switch d {
                    case 0: return true
                    case 1: return false
                    default: throw typeMismatch(Bool.self, bool)
                }
            case let .string(s):
                if let b = Bool(s) { return b }
                if let b = Decimal(string: s) {
                    return NSDecimalNumber(decimal: b).boolValue
                }
                fallthrough
            case .array, .object, .null:
                throw typeMismatch(Bool.self, bool)
        }
    }
}

// MARK: - Property Wrapper

extension _JSONDecoder {
    func fuck()  {
        logger.debug("fuck")
    }
}

// MARK: - Error Handling

private extension _JSONDecoder {
    func typeMismatch(_ expectation: Any.Type, _ reality: JSONValue) -> DecodingError {
        let context = DecodingError.Context(
                codingPath: codingPath,
                debugDescription: "Expected to decode \(expectation) but found \(reality)) instead."
        )
        return .typeMismatch(expectation, context)
    }

    func numberMisfit(_ expectation: Any.Type, _ reality: CustomStringConvertible) -> DecodingError {
        let context = DecodingError.Context(
                codingPath: codingPath,
                debugDescription: "Parsed JSON number <\(reality)> does not fit in \(expectation)."
        )
        return .dataCorrupted(context)
    }
}
