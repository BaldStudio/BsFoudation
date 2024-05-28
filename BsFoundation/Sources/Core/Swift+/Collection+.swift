//
//  Collection+.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/16.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

public extension Collection {
    subscript (safe index: Self.Index) -> Iterator.Element? {
        (startIndex ..< endIndex).contains(index) ? self[index] : nil
    }
    
    func safe(objectAt index: Self.Index) -> Iterator.Element? {
        self[safe: index]
    }
    
    var isNotEmpty: Bool {
        !isEmpty
    }
}

// MARK: - Dictionary

public extension Dictionary {
    static var empty: [Key: Value] { [:] }
    
    func contains(_ key: Key) -> Bool {
        index(forKey: key) != nil
    }
    
    func contains(_ value: Value) -> Bool where Value: Equatable {
        contains { $0.1 == value }
    }
    
    // MARK: - Safe Access
    
    func safe<T>(valueForKey key: Key) -> T? {
        guard let value = self[key] else { return nil }
        if value is NSNull { return nil }
        return value as? T
    }
    
    func safe(boolForKey key: Key) -> Bool {
        guard let value: Any = safe(valueForKey: key) else { return false }
        if let result = value as? Bool { return result }
        if let result = value as? Int { return result.asBool }
        if let result = value as? String { return result.asBool }
        return false
    }
    
    func safe(intForKey key: Key) -> Int {
        guard let value: Any = safe(valueForKey: key) else { return 0 }
        if let result = value as? Int { return result }
        if let result = value as? String { return Int(result) ?? 0 }
        return 0
    }
    
    func safe(stringForKey key: Key) -> String {
        guard let value: Any = safe(valueForKey: key) else { return "" }
        if let result = value as? String { return result }
        if let result = value as? Int { return String(result) }
        return ""
    }
    
    func safe(dictionaryForKey key: Key) -> Self {
        guard let value: Any = safe(valueForKey: key) else { return [:] }
        if let result = value as? Self { return result }
        return [:]
    }
    
    func safe(arrayForKey key: Key) -> [Any] {
        guard let value: Any = safe(valueForKey: key) else { return [] }
        if let result = value as? [Any] { return result }
        return []
    }
    
    static func += (lhs: inout [Key: Value], rhs: [Key: Value]) {
        lhs.merge(rhs) { _, new in new }
    }
}

public extension Array {
    static var empty: [Element] { [] }
}

// MARK: - JSONString

private enum JSONString {
    static let emptyArray = "[]"
    static let emptyDictionary = "{}"
}

public extension Dictionary {
    var asJSONString: String {
        guard JSONSerialization.isValidJSONObject(self) else { return JSONString.emptyDictionary }
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self,
                                                         options: .prettyPrinted) else {
            return JSONString.emptyDictionary
        }
        return String(data: jsonData, encoding: .utf8) ?? JSONString.emptyDictionary
    }
}

public extension Array {
    var asJSONString: String {
        guard JSONSerialization.isValidJSONObject(self) else { return JSONString.emptyArray }
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else {
            return JSONString.emptyArray
        }
        return String(data: jsonData, encoding: .utf8) ?? JSONString.emptyArray
    }
}

