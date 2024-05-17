//
//  JSONParser.swift
//  BsFoundation
//
//  Created by 常润泽 on 2024/2/2.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

struct _JSONParser {
    private let omitNulls: Bool
    private let allowFragments: Bool
    private let allowComments: Bool

    private var pointer: UnsafePointer<UTF8.CodeUnit>
    private var buffer: UnsafeBufferPointer<UTF8.CodeUnit>

    private var stringBuffer: [UTF8.CodeUnit] = []

    private init(bufferPointer: UnsafeBufferPointer<UTF8.CodeUnit>, options: Option) throws {
        guard let ptr = bufferPointer.baseAddress, ptr != bufferPointer.endAddress else {
            throw error(0, .emptyStream)
        }

        buffer = bufferPointer
        pointer = ptr
        omitNulls = options.contains(.omitNulls)
        allowFragments = options.contains(.allowFragments)
        allowComments = options.contains(.allowComments)
    }
}

extension _JSONParser {
    static func parse(_ string: String, options: Option = .none) throws -> JSONValue {
        try parse(Array(string.utf8), options: options)
    }

    static func parse(_ data: Data, options: Option = .none) throws -> JSONValue {
        try data.withUnsafeBytes {
            let pointer = $0.baseAddress!.assumingMemoryBound(to: UTF8.CodeUnit.self)
            return try parse(UnsafeBufferPointer(start: pointer, count: data.count), options: options)
        }
    }

    private static func parse(_ buffer: UnsafeBufferPointer<UTF8.CodeUnit>, options: Option = .none) throws -> JSONValue {
        var parser = try _JSONParser(bufferPointer: buffer, options: options)
        do {
            let root = try parser.parseValue()
            if !parser.allowFragments {
                switch root {
                    case .array, .object: break
                    default: throw error(.fragmentedJSON)
                }
            }
            guard parser.pointer == parser.buffer.endAddress else {
                throw error(.invalidSyntax)
            }
            return root
        } catch let reason as JSONParserError.Reason {
            throw error(parser.buffer.baseAddress!.distance(to: parser.pointer), reason)
        }
    }

    private static func parse(_ data: [UTF8.CodeUnit], options: Option = .none) throws -> JSONValue {
        try data.withUnsafeBufferPointer {
            try parse($0, options: options)
        }
    }
}

// MARK: - Option

extension _JSONParser {
    struct Option: OptionSet {
        let rawValue: UInt8

        init(rawValue: UInt8) { self.rawValue = rawValue }

        static let none: Option = []

        static let omitNulls = Option(rawValue: 1 << 0)
        static let allowFragments = Option(rawValue: 1 << 1)
        static let allowComments = Option(rawValue: 1 << 2)
    }
}

// MARK: - Private

private extension _JSONParser {
    mutating func skipWhitespace() throws {
        while pointer < buffer.endAddress, pointer.pointee.isWhitespace {
            pop()
        }
        if allowComments {
            let wasComment = try skipComments()
            if wasComment { try skipWhitespace() }
        }
    }

    mutating func skipComments() throws -> Bool {
        if hasPrefix(ASCII.lineComment) {
            while let char = peek(), char != ASCII.newline {
                pop()
            }
            return true
        } else if hasPrefix(ASCII.blockCommentStart) {
            pop() // '/'
            pop() // '*'
            var depth: UInt = 1
            repeat {
                guard peek().isNotNil else {
                    throw error(.unmatchedComment)
                }
                if hasPrefix(ASCII.blockCommentEnd) {
                    depth -= 1
                } else if hasPrefix(ASCII.blockCommentStart) {
                    depth += 1
                }
                pop()
            } while depth > 0
            pop() // '/'
            return true
        }
        return false
    }

    mutating func parseUnicodeEscape() throws -> UTF16.CodeUnit {
        var code: UInt16 = 0
        for _ in 0..<4 {
            let c = pop()
            code <<= 4
            switch c {
                case ASCII.numbers:
                    code += UInt16(c - 48)
                case ASCII.alphaNumericUpper:
                    code += UInt16(c - 55)
                case ASCII.alphaNumericLower:
                    code += UInt16(c - 87)
                default:
                    throw error(.invalidEscape)
            }
        }
        return code
    }

    mutating func parseUnicodeScalar() throws -> UnicodeScalar {
        var buffer: [UTF16.CodeUnit] = []
        let code = try parseUnicodeEscape()
        buffer.append(code)
        if UTF16.isLeadSurrogate(code) {
            guard pop() == ASCII.backslash && pop() == ASCII.u else { throw error(.invalidUnicode) }
            let trailingSurrogate = try parseUnicodeEscape()
            guard UTF16.isTrailSurrogate(trailingSurrogate) else { throw error(.invalidUnicode) }
            buffer.append(trailingSurrogate)
        }
        var gen = buffer.makeIterator()
        var utf = UTF16()
        switch utf.decode(&gen) {
            case .scalarValue(let scalar):
                return scalar
            case .emptyInput, .error:
                throw error(.invalidUnicode)
        }
    }

    func peek(aheadBy n: Int = 0) -> UTF8.CodeUnit? {
        let shiftedPointer = pointer.advanced(by: n)
        guard shiftedPointer < buffer.endAddress else {
            return nil
        }
        return shiftedPointer.pointee
    }

    @discardableResult
    mutating func pop() -> UTF8.CodeUnit {
        assert(pointer < buffer.endAddress)
        defer { movePointer(offset: 1) }
        return pointer.pointee
    }

    mutating func movePointer(offset: Int) {
        pointer = pointer.advanced(by: offset)
    }

    func hasPrefix(_ prefix: [UTF8.CodeUnit]) -> Bool {
        guard prefix.isNotEmpty else { return true }
        for (i, b) in prefix.enumerated() {
            guard b == peek(aheadBy: i) else { return false }
        }
        return true
    }
}

private extension _JSONParser {
    mutating func parseValue() throws -> JSONValue {
        try skipWhitespace()
        assert(!pointer.pointee.isWhitespace)
        defer { try? skipWhitespace() }

        switch peek() {
            case ASCII.openbrace:
                return try parseObject()
            case ASCII.openbracket:
                return try parseArray()
            case ASCII.quote:
                return try .string(parseString())
            case ASCII.minus, ASCII.numbers:
                return try parseNumber()
            case ASCII.f:
                pop()
                try assertFollowedBy(ASCII.alse)
                return .bool(false)
            case ASCII.t:
                pop()
                try assertFollowedBy(ASCII.rue)
                return .bool(true)
            case ASCII.n:
                pop()
                try assertFollowedBy(ASCII.ull)
                return .null
            default:
                throw error(.invalidSyntax)
        }
    }

    mutating func parseObject() throws -> JSONValue {
        assert(peek() == ASCII.openbrace)
        pop()
        try skipWhitespace()
        if peek() == ASCII.closebrace {
            pop()
            return .object([:])
        }

        var json: JSONObject = JSONObject(minimumCapacity: 6)
        var wasComma = false
        repeat {
            switch peek() {
                case ASCII.comma:
                    guard !wasComma else { throw error(.expectedComma) }
                    wasComma = true
                    pop()
                    try skipWhitespace()
                case ASCII.quote:
                    if json.isNotEmpty, !wasComma {
                        throw error(.expectedComma)
                    }
                    let key = try parseString()
                    try skipWhitespace()
                    guard pop() == ASCII.colon else { throw error(.expectedColon) }
                    let value = try parseValue()
                    wasComma = false
                    switch value {
                        case .null where omitNulls: break
                        default: json[key] = value
                    }
                case ASCII.closebrace:
                    guard !wasComma else { throw error(.trailingComma) }
                    pop()
                    return .object(json)
                default:
                    throw error(.invalidSyntax)
            }
        } while true
    }

    mutating func parseArray() throws -> JSONValue {
        assert(peek() == ASCII.openbracket)
        pop()
        try skipWhitespace()
        if peek() == ASCII.closebracket {
            pop()
            return .array([])
        }
        var values: [JSONValue] = []
        values.reserveCapacity(6)
        var wasComma = false
        repeat {
            switch peek() {
                case ASCII.comma:
                    guard !wasComma else { throw error(.invalidSyntax) }
                    guard values.isNotEmpty else { throw error(.invalidSyntax) }
                    wasComma = true
                    pop()
                    try skipWhitespace()
                case ASCII.closebracket:
                    guard !wasComma else { throw error(.trailingComma) }
                    pop()
                    return .array(values)
                case nil:
                    throw error(.endOfStream)
                default:
                    if !wasComma, values.isNotEmpty {
                        throw error(.expectedComma)
                    }
                    let value = try parseValue()
                    wasComma = false
                    switch value {
                        case .null where omitNulls:
                            if peek() == ASCII.comma {
                                wasComma = true
                                pop()
                                try skipWhitespace()
                            }
                        default: values.append(value)
                    }
            }
        } while true
    }

    mutating func parseNumber() throws -> JSONValue {
        struct NumberFlags {
            var significand: UInt64 = 0
            var mantisa: UInt64 = 0
            var divisor: Double = 1
            var exponent: UInt64 = 0
            var negativeExponent = false
            var didOverflow = false

            var hasExponent = false
            var hasDecimal = false

            var isNegative: Bool

            init(isNegative: () -> Bool) {
                self.isNegative = isNegative()
            }

            func construct() throws -> JSONValue {
                if hasDecimal || hasExponent {
                    var divisor = divisor
                    divisor /= 10
                    let number = Double(isNegative ? -1 : 1) * (Double(significand) + Double(mantisa) / divisor)
                    guard hasExponent else { return .double(number) }
                    return .double(Double(number) * pow(10, negativeExponent ? -Double(exponent) : Double(exponent)))
                } else {
                    switch significand {
                        case ASCII.validUnsigned64BitInteger where !isNegative:
                            return .integer(Int64(significand))
                        case UInt64(Int64.max) + 1 where isNegative:
                            return .integer(Int64.min)
                        case ASCII.validUnsigned64BitInteger where isNegative:
                            return .integer(-Int64(significand))
                        default:
                            throw error(.numberOverflow)
                    }
                }
            }
        }

        assert(ASCII.numbers ~= peek() || ASCII.minus == peek())
        var f = NumberFlags(isNegative: {
            guard peek() == ASCII.minus else { return false }
            pop()
            return true
        })
        repeat {
            switch peek() {
                case ASCII.numbers where !f.hasDecimal && !f.hasExponent:
                    (f.significand, f.didOverflow) = f.significand.multipliedReportingOverflow(by: 10)
                    guard !f.didOverflow else { throw error(.numberOverflow) }
                    (f.significand, f.didOverflow) = f.significand.addingReportingOverflow(UInt64(pop() - ASCII.zero))
                    guard !f.didOverflow else { throw error(.numberOverflow) }
                case ASCII.numbers where f.hasDecimal && !f.hasExponent:
                    f.divisor *= 10
                    (f.mantisa, f.didOverflow) = f.mantisa.multipliedReportingOverflow(by: 10)
                    guard !f.didOverflow else { throw error(.numberOverflow) }
                    (f.mantisa, f.didOverflow) = f.mantisa.addingReportingOverflow(UInt64(pop() - ASCII.zero))
                    guard !f.didOverflow else { throw error(.numberOverflow) }
                case ASCII.numbers where f.hasExponent:
                    (f.exponent, f.didOverflow) = f.exponent.multipliedReportingOverflow(by: 10)
                    guard !f.didOverflow else { throw error(.numberOverflow) }
                    (f.exponent, f.didOverflow) = f.exponent.addingReportingOverflow(UInt64(pop() - ASCII.zero))
                    guard !f.didOverflow else { throw error(.numberOverflow) }
                case ASCII.decimal where !f.hasExponent && !f.hasDecimal:
                    pop()
                    f.hasDecimal = true
                    guard ASCII.numbers ~= peek() else { throw error(.invalidNumber) }
                case ASCII.E where !f.hasExponent, ASCII.e where !f.hasExponent:
                    pop()
                    f.hasExponent = true
                    if peek() == ASCII.minus {
                        f.negativeExponent = true
                        pop()
                    } else if peek() == ASCII.plus {
                        pop()
                    }
                    guard ASCII.numbers ~= peek() else { throw error(.invalidNumber) }
                case let value? where value.isTerminator:
                    fallthrough
                case nil:
                    return try f.construct()
                default: throw error(.invalidNumber)
            }
        } while true
    }

    mutating func parseString() throws -> String {
        assert(peek() == ASCII.quote)
        pop()
        var escaped = false
        stringBuffer.removeAll(keepingCapacity: true)
        repeat {
            guard let code = peek() else { throw error(.invalidEscape) }
            pop()
            if code == ASCII.backslash && !escaped {
                escaped = true
            } else if code == ASCII.quote && !escaped {
                stringBuffer.append(0)
                return stringBuffer.withUnsafeBufferPointer {
                    String(cString: unsafeBitCast($0.baseAddress, to: UnsafePointer<CChar>.self))
                }
            } else if escaped {
                switch code {
                    case ASCII.r:
                        stringBuffer.append(ASCII.cr)
                    case ASCII.t:
                        stringBuffer.append(ASCII.tab)
                    case ASCII.n:
                        stringBuffer.append(ASCII.newline)
                    case ASCII.b:
                        stringBuffer.append(ASCII.backspace)
                    case ASCII.f:
                        stringBuffer.append(ASCII.formfeed)
                    case ASCII.quote:
                        stringBuffer.append(ASCII.quote)
                    case ASCII.slash:
                        stringBuffer.append(ASCII.slash)
                    case ASCII.backslash:
                        stringBuffer.append(ASCII.backslash)
                    case ASCII.u:
                        let scalar = try parseUnicodeScalar()
                        UTF8.encode(scalar, into: {
                            stringBuffer.append($0)
                        })
                    default:
                        throw error(.invalidEscape)
                }
                escaped = false
            } else if ASCII.isInvalidCode(code) {
                throw error(.invalidUnicode)
            } else {
                stringBuffer.append(code)
            }
        } while true
    }

    mutating func assertFollowedBy(_ chars: [UTF8.CodeUnit]) throws {
        try chars.forEach {
            guard pop() == $0 else { throw JSONParserError.Reason.invalidLiteral }
        }
    }
}

// MARK: - Helpers

fileprivate extension UnsafeBufferPointer {
    var endAddress: UnsafePointer<Element> {
        baseAddress!.advanced(by: endIndex)
    }
}

fileprivate extension UTF8.CodeUnit {
    var isWhitespace: Bool {
        ASCII.whitespace.contains(self)
    }

    var isTerminator: Bool {
        isWhitespace || ASCII.closure.contains(self)
    }
}

extension Optional where Wrapped: Equatable {
    static func ~=(lhs: Wrapped, rhs: Optional<Wrapped>) -> Bool {
        guard let rhs = rhs else { return false }
        return lhs ~= rhs
    }
}

extension RangeExpression {
    static func ~=(lhs: Self, rhs: Optional<Bound>) -> Bool {
        guard let rhs = rhs else { return false }
        return lhs ~= rhs
    }
}

