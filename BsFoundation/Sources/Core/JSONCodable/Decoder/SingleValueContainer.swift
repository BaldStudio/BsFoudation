//
//  SingleValueDecodingContainer.swift
//  BsFoundation
//
//  Created by 常润泽 on 2024/2/1.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

struct _SingleValueDecodingContainer: SingleValueDecodingContainer {
    var codingPath: [CodingKey] {
        get { decoder.codingPath }
        set { decoder.codingPath = newValue }
    }

    private unowned let decoder: _JSONDecoder
    private let currentObject: JSONValue

    init(referencing decoder: _JSONDecoder, wrapping object: JSONValue) {
        self.decoder = decoder
        currentObject = object
    }
}

// MARK: - Decode

extension _SingleValueDecodingContainer {
    func decodeNil() -> Bool {
        decoder.unbox(null: currentObject)
    }

    func decode(_: Bool.Type) throws -> Bool {
        try decoder.unbox(bool: currentObject)
    }

    func decode(_: Int.Type) throws -> Int {
        try decoder.unbox(integer: currentObject)
    }

    func decode(_: Int8.Type) throws -> Int8 {
        try decoder.unbox(integer: currentObject)
    }

    func decode(_: Int16.Type) throws -> Int16 {
        try decoder.unbox(integer: currentObject)
    }

    func decode(_: Int32.Type) throws -> Int32 {
        try decoder.unbox(integer: currentObject)
    }

    func decode(_: Int64.Type) throws -> Int64 {
        try decoder.unbox(integer: currentObject)
    }

    func decode(_: UInt.Type) throws -> UInt {
        try decoder.unbox(integer: currentObject)
    }

    func decode(_: UInt8.Type) throws -> UInt8 {
        try decoder.unbox(integer: currentObject)
    }

    func decode(_: UInt16.Type) throws -> UInt16 {
        try decoder.unbox(integer: currentObject)
    }

    func decode(_: UInt32.Type) throws -> UInt32 {
        try decoder.unbox(integer: currentObject)
    }

    func decode(_: UInt64.Type) throws -> UInt64 {
        try decoder.unbox(integer: currentObject)
    }

    func decode(_: Float.Type) throws -> Float {
        try decoder.unbox(double: currentObject)
    }

    func decode(_: Double.Type) throws -> Double {
        try decoder.unbox(double: currentObject)
    }

    func decode(_: String.Type) throws -> String {
        try decoder.unbox(string: currentObject)
    }

    func decode<T: Decodable>(_: T.Type) throws -> T {
        try decoder.unbox(object: currentObject)
    }
}
