//
//  JSONError.swift
//  BsFoundation
//
//  Created by 常润泽 on 2024/2/2.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

struct JSONParserError: Error, Equatable {
    var byteOffset: Int
    var reason: Reason
    
    enum Reason: Error {
        case invalidJSON
        case emptyStream
        case endOfStream
        case fragmentedJSON
        case invalidSyntax
        case invalidLiteral
        case trailingComma
        case expectedComma
        case expectedColon
        case numberOverflow
        case invalidNumber
        case invalidEscape
        case invalidUnicode
        case unmatchedComment
        case interruptByUser
    }
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.reason == rhs.reason && lhs.byteOffset == rhs.byteOffset
    }
}

func error(_ reason: @autoclosure () throws -> JSONParserError.Reason) rethrows -> JSONParserError.Reason {
    try reason()
}

func error(_ byteOffset: @autoclosure () throws -> Int,
           _ reason: @autoclosure () throws -> JSONParserError.Reason) rethrows -> JSONParserError {
    JSONParserError(byteOffset: try byteOffset(), reason: try reason())
}
