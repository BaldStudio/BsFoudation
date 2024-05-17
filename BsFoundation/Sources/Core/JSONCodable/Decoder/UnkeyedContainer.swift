//
//  UnkeyedContainer.swift
//  BsFoundation
//
//  Created by changrunze on 2024/2/4.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

struct _UnkeyedContainer: UnkeyedDecodingContainer {
    var codingPath: [CodingKey] {
        get { decoder.codingPath }
        set { decoder.codingPath = newValue }
    }

    var count: Int? {
        sequence.count
    }

    var isAtEnd: Bool {
        currentIndex >= sequence.count
    }

    var currentIndex: Int

    private unowned let decoder: _JSONDecoder
    private let sequence: [JSONValue]

    init(referencing decoder: _JSONDecoder, wrapping container: [JSONValue]) {
        self.decoder = decoder
        sequence = container
        currentIndex = 0
    }

    private var currentKey: CodingKey {
        JSONKey(index: currentIndex)
    }
}

// MARK: - Decode

extension _UnkeyedContainer {
    mutating func decodeNil() throws -> Bool {
        try decoder.unbox(null: currentObject(), forKey: currentKey)
    }

    mutating func decode(_ type: Bool.Type) throws -> Bool {
        try decoder.unbox(bool: currentObject(), forKey: currentKey)
    }

    mutating func decode(_ type: Int.Type) throws -> Int {
        try decoder.unbox(integer: currentObject(), forKey: currentKey)
    }

    mutating func decode(_ type: Int8.Type) throws -> Int8 {
        try decoder.unbox(integer: currentObject(), forKey: currentKey)
    }

    mutating func decode(_ type: Int16.Type) throws -> Int16 {
        try decoder.unbox(integer: currentObject(), forKey: currentKey)
    }

    mutating func decode(_ type: Int32.Type) throws -> Int32 {
        try decoder.unbox(integer: currentObject(), forKey: currentKey)
    }

    mutating func decode(_ type: Int64.Type) throws -> Int64 {
        try decoder.unbox(integer: currentObject(), forKey: currentKey)
    }

    mutating func decode(_ type: UInt.Type) throws -> UInt {
        try decoder.unbox(integer: currentObject(), forKey: currentKey)
    }

    mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
        try decoder.unbox(integer: currentObject(), forKey: currentKey)
    }

    mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
        try decoder.unbox(integer: currentObject(), forKey: currentKey)
    }

    mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
        try decoder.unbox(integer: currentObject(), forKey: currentKey)
    }

    mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
        try decoder.unbox(integer: currentObject(), forKey: currentKey)
    }

    mutating func decode(_ type: Float.Type) throws -> Float {
        try decoder.unbox(double: currentObject(), forKey: currentKey)
    }

    mutating func decode(_ type: Double.Type) throws -> Double {
        try decoder.unbox(double: currentObject(), forKey: currentKey)
    }

    mutating func decode(_ type: String.Type) throws -> String {
        try decoder.unbox(string: currentObject(), forKey: currentKey)
    }

    mutating func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        try decoder.unbox(object: currentObject(), forKey: currentKey)
    }
}

// MARK: - Nest Container

extension _UnkeyedContainer {
    mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        defer { codingPath.removeLast() }
        codingPath.append(currentKey)
        return try decoder.container(keyedBy: type, wrapping: currentObject())
    }

    mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        try decoder.unkeyedContainer(wrapping: currentObject())
    }

    mutating func superDecoder() throws -> Decoder {
        _JSONDecoder(referencing: .array(sequence), at: decoder.codingPath)
    }
}

// MARK: - Private

private extension _UnkeyedContainer {
    mutating func currentObject() throws -> JSONValue {
        guard !isAtEnd else {
            let context = DecodingError.Context(
                    codingPath: decoder.codingPath + [currentKey],
                    debugDescription: "Unkeyed container is at end."
            )
            throw DecodingError.valueNotFound(JSONValue.self, context)
        }
        defer { currentIndex += 1 }
        return sequence[currentIndex]
    }
}
