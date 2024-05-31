//
//  KeychainSerializable.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/31.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

import Foundation

// MARK: -  Keychain Serializable

public protocol KeychainSerializable {
    associatedtype Value
    static var serializer: Keychain.Serializer<Value> { get }
}

// TODO: 不要污染外部命名空间

extension Int: KeychainSerializable {
    public static var serializer: Keychain.Serializer<Int> { return Keychain.IntSerializer() }
}

extension String: KeychainSerializable {
    public static var serializer: Keychain.Serializer<String> { return Keychain.StringSerializer() }
}

extension Double: KeychainSerializable {
    public static var serializer: Keychain.Serializer<Double> { return Keychain.DoubleSerializer() }
}

extension Float: KeychainSerializable {
    public static var serializer: Keychain.Serializer<Float> { return Keychain.FloatSerializer() }
}

extension Bool: KeychainSerializable {
    public static var serializer: Keychain.Serializer<Bool> { return Keychain.BoolSerializer() }
}

extension Data: KeychainSerializable {
    public static var serializer: Keychain.Serializer<Data> { return Keychain.DataSerializer() }
}

extension KeychainSerializable where Self: Codable {
    public static var serializer: Keychain.Serializer<Self> { return Keychain.CodableSerializer() }
}

extension KeychainSerializable where Self: NSCoding {
    public static var serializer: Keychain.Serializer<Self> { return Keychain.ArchivableSerializer() }
}

// MARK: -  Serializer

extension Keychain {
    open class Serializer<Value> {
        open func encode(_ value: Value) throws -> Data { fatalError() }
        open func decode(_ data: Data) throws -> Value? { fatalError() }
        public init() {}
    }
}

extension Keychain.Serializer {
    func set<T: KeychainSerializable>(_ value: Value, forKey key: Keychain.Key<T>, in keychain: Keychain) throws {
        typealias Attribute = Keychain.Attribute
        let query: AnyAttributes = keychain.queryAttributes + key.queryAttributes + [Attribute.account(key.key)]
        let status = Keychain.fetchItem(query)
        switch status {
            // Keychain already contains key -> update existing item
            case errSecSuccess:
                let attributesToUpdate = key.updateRequestAttributes + [Attribute.data(try encode(value))]
                let status = Keychain.updateItem(query, attributesToUpdate)
                if status != errSecSuccess {
                    throw KeychainError(status: status)
                }
            // Keychain doesn't contain key -> add new item
            case errSecItemNotFound:
                let attributesToAdd = keychain.queryAttributes
                        + key.queryAttributes
                        + key.updateRequestAttributes
                        + [Attribute.account(key.key), Attribute.data(try encode(value))]
                let status = Keychain.addItem(attributesToAdd)
                if status != errSecSuccess {
                    throw KeychainError(status: status)
                }
            // This error can happen when your app is launched in the background while the device is locked
            // (for example, in response to an actionable push notification or a Core Location geofence event),
            // the application may crash as a result of accessing a locked keychain entry.
            //
            // TODO: Maybe introduce `force` property to allow remove and save key with different permissions
            case errSecInteractionNotAllowed:
                throw KeychainError(status: status)
            default:
                throw KeychainError(status: status)
        }
    }
    
    func value<T: KeychainSerializable>(for key: Keychain.Key<T>, in keychain: Keychain) throws -> Value? {
        typealias Attribute = Keychain.Attribute
        let query: AnyAttributes = keychain.queryAttributes
                + key.queryAttributes
                + [Attribute.account(key.key)]
                + [Attribute.SearchResult.matchLimit(.one)]
                + [Attribute.ReturnResult.data(true)]
        var result: AnyObject?
        let status = SecItemCopyMatching(query.compose(), &result)
        switch status {
            case errSecSuccess:
                guard let data = result as? Data else {
                    throw KeychainError.unexpectedError
                }
                return try decode(data)
            case errSecItemNotFound:
                return nil
            default:
                throw KeychainError(status: status)
        }
    }
    
    func removeValue<T: KeychainSerializable>(for key: Keychain.Key<T>, in keychain: Keychain) throws {
        typealias Attribute = Keychain.Attribute
        let query: AnyAttributes = keychain.queryAttributes
                + key.queryAttributes
                + [Attribute.account(key.key)]
        let status = Keychain.deleteItem(query)
        if status != errSecSuccess && status != errSecItemNotFound {
            throw KeychainError(status: status)
        }
    }
    
    func attributes<T: KeychainSerializable>(for key: Keychain.Key<T>, in keychain: Keychain) throws -> [Keychain.Attribute] {
        typealias Attribute = Keychain.Attribute
        let returnAttributes = [
            Attribute.ReturnResult.attributes(true),
            Attribute.ReturnResult.reference(true),
            Attribute.ReturnResult.persistentReference(true)
        ]
        let query: AnyAttributes = keychain.queryAttributes
                + key.queryAttributes
                + [Attribute.account(key.key)]
                + [Attribute.SearchResult.matchLimit(.one)]
                + returnAttributes
        var result: AnyObject?
        let status = SecItemCopyMatching(query.compose(), &result)
        switch status {
            case errSecSuccess:
                guard let data = result as? [String: Any] else {
                    throw KeychainError.unexpectedError
                }
                return data.compactMap { Attribute(key: $0, value: $1) }
            default: 
            throw KeychainError(status: status)
        }
    }
}

private extension Keychain {
    final class IntSerializer: Serializer<Int> {
        override func encode(_ value: Int) throws -> Data {
            Data(from: value)
        }

        override func decode(_ data: Data) throws -> Int? {
            data.convert(type: Int.self)
        }
    }

    final class StringSerializer: Serializer<String> {
        override func encode(_ value: String) throws -> Data {
            guard let data = value.data(using: .utf8) else {
                throw KeychainError.conversionError
            }
            return data
        }

        override func decode(_ data: Data) throws -> String? {
            String(data: data, encoding: .utf8)
        }
    }

    final class DoubleSerializer: Serializer<Double> {
        override func encode(_ value: Double) throws -> Data {
            Data(from: value)
        }

        override func decode(_ data: Data) throws -> Double? {
            data.convert(type: Double.self)
        }
    }

    final class FloatSerializer: Serializer<Float> {
        override func encode(_ value: Float) throws -> Data {
            Data(from: value)
        }

        override func decode(_ data: Data) throws -> Float? {
            data.convert(type: Float.self)
        }
    }

    final class BoolSerializer: Serializer<Bool> {
        override func encode(_ value: Bool) throws -> Data {
            let bytes: [UInt8] = value ? [1] : [0]
            return Data(bytes)
        }

        override func decode(_ data: Data) throws -> Bool? {
            guard let firstBit = data.first else {
                return nil
            }
            return firstBit == 1
        }
    }

    final class DataSerializer: Serializer<Data> {
        override func encode(_ value: Data) throws -> Data {
            value
        }

        override func decode(_ data: Data) throws -> Data? {
            data
        }
    }

    final class CodableSerializer<T: Codable>: Serializer<T> {
        override func encode(_ value: T) throws -> Data {
            try JSONEncoder().encode(value)
        }

        override func decode(_ data: Data) throws -> T? {
            try JSONDecoder().decode(T.self, from: data)
        }
    }

    final class ArchivableSerializer<T: NSCoding>: Serializer<T> {
        override func encode(_ value: T) throws -> Data {
            // TODO: iOS 13 deprecated +archivedDataWithRootObject:requiringSecureCoding:error:
            NSKeyedArchiver.archivedData(withRootObject: value)
        }

        override func decode(_ data: Data) throws -> T? {
            // TODO: iOS 13 deprecated +unarchivedObjectOfClass:fromData:error:
            guard let value = NSKeyedUnarchiver.unarchiveObject(with: data) as? T else {
                throw KeychainError.invalidDataCast
            }
            return value
        }
    }
}

private extension Data {
    init<T>(from value: T) {
        self = Swift.withUnsafeBytes(of: value) { Data($0) }
    }

    // TODO: Throw KeychainError.conversionError instead of nil
    func convert<T: ExpressibleByIntegerLiteral>(type: T.Type) -> T? {
        var value: T = 0
        guard count >= MemoryLayout.size(ofValue: value) else { return nil }
        _ = Swift.withUnsafeMutableBytes(of: &value, { copyBytes(to: $0)} )
        return value
    }
}

