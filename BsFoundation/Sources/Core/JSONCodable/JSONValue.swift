//
//  JSONValue.swift
//  BsFoundation
//
//  Created by 常润泽 on 2024/2/1.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

// MARK: - JSONValue

enum JSONValue {
    indirect case array([Self])
    indirect case object([String: Self])
    case null
    case bool(Bool)
    case string(String)
    case double(Double)
    case integer(Int64)
}

// MARK: - Sequence

extension JSONValue: Sequence {
    public func makeIterator() -> AnyIterator<JSONValue> {
        switch self {
            case let .array(array):
                var iterator = array.makeIterator()
                return AnyIterator { iterator.next() }
            case let .object(object):
                var iterator = object.makeIterator()
                return AnyIterator {
                    guard let (key, value) = iterator.next() else { return nil }
                    return .object([key: value])
                }
            default:
                var value: JSONValue? = self
                return AnyIterator {
                    defer { value = nil }
                    if case .null? = value { return nil }
                    return value
                }
        }
    }
}

// MARK: - Equatable

extension JSONValue: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
            case let (.array(l), .array(r)): return l == r
            case let (.object(l), .object(r)): return l == r
            case (.null, .null): return true
            case let (.bool(l), .bool(r)): return l == r
            case let (.string(l), .string(r)): return l == r
            case let (.double(l), .double(r)): return l == r
            case let (.integer(l), .integer(r)): return l == r
            default: return false
        }
    }
}

// MARK: - CustomStringConvertible

extension JSONValue: CustomStringConvertible {
    public var description: String {
        switch self {
            case let .array(array): return array.description
            case let .object(object): return object.description
            case let .bool(bool): return bool.description
            case let .string(string): return string.description
            case let .double(double): return double.description
            case let .integer(integer): return integer.description
            case .null: return "<null>"
        }
    }
}

// MARK: - JSONValueConvertible

protocol JSONValueConvertible {
    static var defaultValue: Self { get }
    func encoded() -> JSONValue
}

extension JSONValue: JSONValueConvertible {
    init(_ value: JSONValueConvertible) {
        self = value.encoded()
    }

    func encoded() -> JSONValue { self }
    
    static var defaultValue: Self { .null }
}

// MARK: - Optional

extension Optional where Wrapped: JSONValueConvertible {
    func encoded() -> JSONValue {
        switch self {
            case .some(let value): return value.encoded()
            case .none: return .null
        }
    }
}

// MARK: - RawRepresentable

extension RawRepresentable where RawValue: JSONValueConvertible {
    func encoded() -> JSONValue { rawValue.encoded() }
}

// MARK: - Sequences of [String: JSONRepresentable]

extension Sequence where Iterator.Element: JSONValueConvertible {
    func encoded() -> JSONValue {
        .array(map({ $0.encoded() }))
    }
}

extension Sequence where Iterator.Element == (key: String, value: JSONValueConvertible) {
    func encoded() -> JSONValue {
        .object(reduce(into: [String: JSONValue](), {
            $0[$1.key] = $1.value.encoded()
        }))
    }
}

// MARK: - Bool

extension Bool: JSONValueConvertible {
    public static var defaultValue: Self { false }
    func encoded() -> JSONValue { .bool(self) }
}

// MARK: - String

extension String: JSONValueConvertible {
    public static var defaultValue: Self { .empty }
    func encoded() -> JSONValue { .string(self) }
}

// MARK: - BinaryFloatingPoint

extension Double: JSONValueConvertible {
    public static var defaultValue: Self { .infinity }
    func encoded() -> JSONValue { .double(self) }
}

extension Float: JSONValueConvertible {
    public static var defaultValue: Self { .infinity }
    func encoded() -> JSONValue { .double(Double(self)) }
}

// MARK: - BinaryInteger

extension Int: JSONValueConvertible {
    public static var defaultValue: Self { .max }
    func encoded() -> JSONValue { .integer(Int64(self)) }
}

extension Int8: JSONValueConvertible {
    public static var defaultValue: Self { .max }
    func encoded() -> JSONValue { .integer(Int64(self)) }
}

extension Int16: JSONValueConvertible {
    public static var defaultValue: Self { .max }
    func encoded() -> JSONValue { .integer(Int64(self)) }
}

extension Int32: JSONValueConvertible {
    public static var defaultValue: Self { .max }
    func encoded() -> JSONValue { .integer(Int64(self)) }
}

extension Int64: JSONValueConvertible {
    public static var defaultValue: Self { .max }
    func encoded() -> JSONValue { .integer(self) }
}

extension UInt: JSONValueConvertible {
    public static var defaultValue: Self { .max }
    func encoded() -> JSONValue { .integer(Int64(self)) }
}

extension UInt8: JSONValueConvertible {
    public static var defaultValue: Self { .max }
    func encoded() -> JSONValue { .integer(Int64(self)) }
}

extension UInt16: JSONValueConvertible {
    public static var defaultValue: Self { .max }
    func encoded() -> JSONValue { .integer(Int64(self)) }
}

extension UInt32: JSONValueConvertible {
    public static var defaultValue: Self { .max }
    func encoded() -> JSONValue { .integer(Int64(self)) }
}

extension UInt64: JSONValueConvertible {
    public static var defaultValue: Self { .max }
    func encoded() -> JSONValue { .integer(Int64(self)) }
}

// MARK - JSONCodableMapperValue

public protocol JSONCodableMapperValue {
    var mappingKeys: [String] { get }
}

extension String: JSONCodableMapperValue {
    public var mappingKeys: [String] { [self] }
}

extension Array: JSONCodableMapperValue where Element == String {
    public var mappingKeys: [String] { self }
}
