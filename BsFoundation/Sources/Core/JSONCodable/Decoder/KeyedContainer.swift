//
//  KeyedContainer.swift
//  BsFoundation
//
//  Created by changrunze on 2024/2/4.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

final class _KeyedContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
    private unowned let decoder: _JSONDecoder
    private let currentObject: JSONObject

    var codingPath: [CodingKey] {
        get { decoder.codingPath }
        set { decoder.codingPath = newValue }
    }

    init(referencing decoder: _JSONDecoder, wrapping object: JSONObject) {
        self.decoder = decoder
        currentObject = object
    }

    var allKeys: [Key] {
        currentObject.keys.compactMap(Key.init)
    }

    func contains(_ key: Key) -> Bool {
        currentObject[key.stringValue].isNotNil
    }
}

// MARK: - Decode

extension _KeyedContainer {
    func decodeNil(forKey key: Key) throws -> Bool {
        decoder.unbox(null: _decode(forKey: key), forKey: key)
    }

    func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        try decoder.unbox(bool: _decode(type, forKey: key), forKey: key)
    }

    func decode(_ type: String.Type, forKey key: Key) throws -> String {
        try decoder.unbox(string: _decode(type, forKey: key), forKey: key)
    }

    func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        try decoder.unbox(double: _decode(type, forKey: key), forKey: key)
    }

    func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        try decoder.unbox(double: _decode(type, forKey: key), forKey: key)
    }

    func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        try decoder.unbox(integer: _decode(type, forKey: key), forKey: key)
    }

    func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        try decoder.unbox(integer: _decode(type, forKey: key), forKey: key)
    }

    func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        try decoder.unbox(integer: _decode(type, forKey: key), forKey: key)
    }

    func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        try decoder.unbox(integer: _decode(type, forKey: key), forKey: key)
    }

    func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        try decoder.unbox(integer: _decode(type, forKey: key), forKey: key)
    }

    func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        try decoder.unbox(integer: _decode(type, forKey: key), forKey: key)
    }

    func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        try decoder.unbox(integer: _decode(type, forKey: key), forKey: key)
    }

    func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        try decoder.unbox(integer: _decode(type, forKey: key), forKey: key)
    }

    func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        try decoder.unbox(integer: _decode(type, forKey: key), forKey: key)
    }

    func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        try decoder.unbox(integer: _decode(type, forKey: key), forKey: key)
    }

    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T: Decodable {
        try decoder.unbox(object: _decode(type, forKey: key), forKey: key)
    }
}

// MARK: - Nest Container

extension _KeyedContainer {
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type,
                                    forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
        defer { codingPath.removeLast() }
        codingPath.append(key)
        let object = _decode(forKey: key)
        return try decoder.container(keyedBy: type, wrapping: object)
    }

    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        defer { codingPath.removeLast() }
        let object = _decode(forKey: key)
        return try decoder.unkeyedContainer(wrapping: object)
    }

    func superDecoder() throws -> Decoder {
        try _superDecoder(forKey: JSONKey.super)
    }

    func superDecoder(forKey key: Key) throws -> Decoder {
        try _superDecoder(forKey: key)
    }

    private func _superDecoder(forKey key: CodingKey) throws -> Decoder {
        defer { codingPath.removeLast() }
        codingPath.append(key)
        if key is JSONKey {
            return _JSONDecoder(referencing: .object(currentObject),
                                at: codingPath)
        }
        return _JSONDecoder(referencing: currentObject[key.stringValue, default: .null],
                            at: codingPath)
    }
}

// MARK: - Private

private extension _KeyedContainer {
    func _decode<T>(_ type: T.Type = JSONValue.self, forKey key: Key) -> JSONValue {
        // 用默认 Key 取值
        let originKey = key.stringValue
        if let obj = currentObject[key.stringValue] { return obj }
        
        // 用 MapperKeys 尝试下
        if let mapper = decoder.target.customPropertyMapper[originKey] {
            for mappingKey in mapper.mappingKeys {
                if let obj = currentObject[mappingKey] { return obj }
            }
        }

        // 再试试默认值
        if let obj = decoder.target.defaultValue(for: key) as? JSONValueConvertible {
            return obj.encoded()
        }
        
        // 用兜底值
        if let type = type as? JSONValueConvertible.Type {
            return type.defaultValue.encoded()
        }
                      
        return .null
    }
}
