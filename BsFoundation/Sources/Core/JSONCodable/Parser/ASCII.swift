//
//  CharacterSet.swift
//  BsFoundation
//
//  Created by 常润泽 on 2024/2/2.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

enum ASCII {
    static let space = UInt8(ascii: " ")
    static let tab = UInt8(ascii: "\t")
    static let cr = UInt8(ascii: "\r")
    static let newline = UInt8(ascii: "\n")
    static let backspace: UInt8 = 0x08
    static let formfeed: UInt8  = 0x0C

    static let colon = UInt8(ascii: ":")
    static let comma = UInt8(ascii: ",")

    static let openbrace = UInt8(ascii: "{")
    static let closebrace = UInt8(ascii: "}")
    
    static let openbracket = UInt8(ascii: "[")
    static let closebracket = UInt8(ascii: "]")
            
    static let quote = UInt8(ascii: "\"")
    static let slash = UInt8(ascii: "/")
    static let backslash = UInt8(ascii: "\\")
    
    static let star = UInt8(ascii: "*")
    
    static let n = UInt8(ascii: "n")
    static let t = UInt8(ascii: "t")
    static let r = UInt8(ascii: "r")
    static let u = UInt8(ascii: "u")
    static let f = UInt8(ascii: "f")
    static let a = UInt8(ascii: "a")
    static let l = UInt8(ascii: "l")
    static let s = UInt8(ascii: "s")
    static let e = UInt8(ascii: "e")
    static let b = UInt8(ascii: "b")
    
    static let E = UInt8(ascii: "E")
    static let A = UInt8(ascii: "A")
    static let F = UInt8(ascii: "F")

    static let zero = UInt8(ascii: "0")
    static let nine = UInt8(ascii: "9")
    static let plus = UInt8(ascii: "+")
    static let minus = UInt8(ascii: "-")
    static let decimal = UInt8(ascii: ".")
    
    static let whitespace = [space, tab, cr, newline, formfeed]
    static let closure = [comma, closebrace, closebracket]

    static let rue = [r, u, e]
    static let alse = [a, l, s, e]
    static let ull = [u, l, l]

    static let numbers: ClosedRange<UInt8> = zero ... nine
    static let alphaNumericLower: ClosedRange<UInt8> = a ... f
    static let alphaNumericUpper: ClosedRange<UInt8> = A ... F
    
    private static let invalidBytes: ClosedRange<UInt8> = 0xF5...0xFF
    static func isInvalidCode(_ code: UInt8) -> Bool {
        invalidBytes.contains(code) || code == 0xC0 || code == 0xC1
    }
    
    static let valid64BitInteger: ClosedRange<Int64> = Int64.min...Int64.max
    static let validUnsigned64BitInteger: ClosedRange<UInt64> = UInt64.min...UInt64(Int64.max)
    
    static let lineComment = [slash, slash]         //  '//'
    static let blockCommentStart = [slash, star]    //  '/*'
    static let blockCommentEnd = [star, slash]      //  '*/'
}
