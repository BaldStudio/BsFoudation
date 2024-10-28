//
//  Collection+.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/16.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

public extension Collection {
    var isNotEmpty: Bool {
        !isEmpty
    }
}

// MARK: - Dictionary

public extension Dictionary {
    static var empty: [Key: Value] { [:] }
    
    func contains(key: Key) -> Bool {
        index(forKey: key) != nil
    }
    
    func contains(value: Value) -> Bool where Value: Equatable {
        contains { $0.1 == value }
    }
    
    // MARK: - Safe Access
    
    func safe<T>(valueForKey key: Key) -> T? {
        // !!!: 暂不考虑兼容 NSNull 的情况
        if let value = self[key] {
            return value as? T
        }
        return nil
    }
        
    func safe(intForKey key: Key) -> Int {
        if let value: Any = safe(valueForKey: key) {
            if let result = value as? Int { return result }
            if let result = value as? String { return result.asInt }
            if let result = value as? Bool { return result.asInt }
            // !!!: 暂不考虑兼容更多类型，减少复杂度
            // if let result = value as? Int16 { return result.asInt }
            // if let result = value as? UInt { return result.asInt }
            // if let result = value as? Float { return result.asInt }
            // if let result = value as? Double { return result.asInt }
            // if let result = value as? CGFloat { return result.asInt }
        }
        return .zero
    }
    
    func safe(boolForKey key: Key) -> Bool {
        if let value: Any = safe(valueForKey: key) {
            if let result = value as? Bool { return result }
            if let result = value as? Int { return result.asBool }
            if let result = value as? String { return result.asBool }
            // !!!: 暂不考虑兼容更多类型，减少复杂度
        }
        return false
    }

    func safe(stringForKey key: Key) -> String {
        if let value: Any = safe(valueForKey: key) {
            if let result = value as? String { return result }
            if let result = value as? Int { return String(result) }
            if let result = value as? Bool { return String(result) }
            // !!!: 暂不考虑兼容更多类型，减少复杂度
        }
        return .empty
    }
    
    func safe<K: Hashable, V>(dictionaryForKey key: Key) -> [K: V] {
        if let value: [K: V] = safe(valueForKey: key) {
            return value
        }
        return .empty
    }
    
    func safe<E>(arrayForKey key: Key) -> [E] {
        if let value: [E] = safe(valueForKey: key) {
            return value
        }
        return .empty
    }
    
    static func += (lhs: inout [Key: Value], rhs: [Key: Value]) {
        lhs.merge(rhs) { _, new in new }
    }
}

public extension Array {
    static var empty: [Element] { [] }
    
    subscript (safe index: Self.Index) -> Iterator.Element? {
        indices.contains(index) ? self[index] : nil
    }
    
    func safe(objectAt index: Self.Index) -> Iterator.Element? {
        self[safe: index]
    }
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

