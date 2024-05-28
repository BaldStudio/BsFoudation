//
//  String+.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/16.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

import CommonCrypto

public extension String {
    static let empty: String = ""

    @inlinable
    var isNotEmpty: Bool {
        !isEmpty
    }
    
    @inlinable
    func slice(at idx: Int = 0, count: Int = .max) -> String {
        let i = min(count, max(idx, 0))
        let len = min(count - i, max(count, 0))
        let begin = index(startIndex, offsetBy: i)
        let end = index(begin, offsetBy: len)
        return String(self[begin..<end])
    }
    
    @inlinable
    var isBlank: Bool {
        trimmed.isEmpty
    }
    
    @inlinable
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    @inlinable
    mutating func trim(_ set: CharacterSet = .whitespacesAndNewlines) {
        self = trimmingCharacters(in: set)
    }
}

// MARK: - URL Coding

private let customEncodingCharacters = "-_.!~*;@$,#"
private let allowedCharacterSet: CharacterSet = {
    var charSet = CharacterSet()
    charSet.formUnion(CharacterSet(charactersIn: customEncodingCharacters))
    charSet.formUnion(.letters)
    charSet.formUnion(.alphanumerics)
    return charSet
}()

public extension String {

    /// 生成URL编码字符串
    /// - Parameters:
    ///   - retain: 保留字符
    ///   - unretain: 去除字符
    /// - Returns: 编码异常时，返回原URL字符串
    func urlEncoded(retain: String? = nil, unretain: String? = nil) -> String {
        var charSet = allowedCharacterSet
        if let characters = retain, characters.isNotEmpty, !characters.isBlank {
            charSet.formUnion(CharacterSet(charactersIn: characters))
        }
        if let characters = unretain, characters.isNotEmpty, !characters.isBlank {
            charSet.remove(charactersIn: characters)
        }
        return addingPercentEncoding(withAllowedCharacters: charSet) ?? self
    }

    mutating func urlEncode(retain: String? = nil, unretain: String? = nil) {
        self = urlEncoded(retain: retain, unretain: unretain)
    }
    
    var urlDecoded: String {
        removingPercentEncoding ?? self
    }
    
    mutating func urlDecode() {
        self = urlDecoded
    }
}

// MARK: - Crypto

public extension String {
    var asMD5: String {
        guard let data = data(using: .utf8) else { return self }
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let hash = data.withUnsafeBytes { bytes -> Bytes in
            var hash = Bytes(repeating: 0, count: length)
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        return (0..<length).map { String(format: "%02x", hash[$0]) }.joined()
    }
}

// MARK: - Slice

public extension String {
    /** Note: Look me
     目前为了方便使用，返回值都统一为String
     这会牺牲一定的性能，因为存在copy的情况
     如果有较多的高性能需要的场景，可以考虑使用原始类型处理，如Substring等
     */
    
    subscript (i: Int) -> String {
        self[index(startIndex, offsetBy: i)].asString
    }
    
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < start { return "" }
        return self[start..<end].asString
    }
    
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < start { return "" }
        return self[start...end].asString
    }
    
    subscript (bounds: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(endIndex, offsetBy: -1)
        if end < start { return "" }
        return self[start...end].asString
    }
    
    subscript (bounds: PartialRangeThrough<Int>) -> String {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < startIndex { return "" }
        return self[startIndex...end].asString
    }
    
    subscript (bounds: PartialRangeUpTo<Int>) -> String {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < startIndex { return "" }
        return self[startIndex..<end].asString
    }
}

// MARK: - Convert

public extension Character {
    @inlinable
    var asString: String {
        String(self)
    }
}

public extension Substring {
    @inlinable
    var asString: String {
        String(self)
    }
}

public extension String {
    @inlinable
    var asInt: Int {
        Int(self) ?? 0
    }

    @inlinable
    var asDouble: Double {
        Double(self) ?? 0
    }

    @inlinable
    var asBool: Bool {
        switch lowercased() {
        case "true", "t", "yes", "y":
            return true
        case "false", "f", "no", "n", "":
            return false
        default:
            if let int = Int(self) {
                return int.asBool
            }
        }
        return false
    }
    
    @inlinable
    var asURL: URL? {
        URL(string: self)
    }
    
    @inlinable
    var asDictionary: [String: Any] {
        let empty: [String: Any] = [:]
        guard let data = data(using: .utf8) else { return empty }
        guard let result = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            return empty
        }
        return result
    }
    
    @inlinable
    var asArray: [Any] {
        let empty: [Any] = []
        guard let data = data(using: .utf8) else { return empty }
        guard let result = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Any] else {
            return empty
        }
        return result
    }
    
    @inlinable
    var asHTMLAttributedString: NSAttributedString {
        let empty = NSAttributedString()
        guard let data = data(using: .utf8) else { return empty }
        let options: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            .documentType: NSAttributedString.DocumentType.html,
        ]
        guard let result = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return empty
        }
        return result
    }
    
    @inlinable
    var asData: Data {
        data(using: .utf8) ?? Data()
    }
}
