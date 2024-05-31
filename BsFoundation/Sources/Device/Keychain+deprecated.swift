////
////  Keychain.swift
////  BsDevice
////
////  Created by crzorz on 2022/8/25.
////  Copyright © 2022 BaldStudio. All rights reserved.
////
//
//import Foundation
//import Security
//
//final class Keychain {
//    
//    let options: Options
//    
//    init(_ opts: Options) {
//        options = opts
//    }
//    
//    convenience init() {
//        var options = Options()
//        if let bundleIdentifier = Bundle.main.bundleIdentifier {
//            options.service = bundleIdentifier
//        }
//        self.init(options)
//    }
//
//    convenience init(service: String) {
//        var options = Options()
//        options.service = service
//        self.init(options)
//    }
//
//    convenience init(accessGroup: String) {
//        var options = Options()
//        if let bundleIdentifier = Bundle.main.bundleIdentifier {
//            options.service = bundleIdentifier
//        }
//        options.accessGroup = accessGroup
//        self.init(options)
//    }
//    
//}
//
//private let ItemClass = String(kSecClass)
//private let ItemClassGenericPassword = String(kSecClassGenericPassword)
//
//private let AttributeAccount = String(kSecAttrAccount)
//private let AttributeService = String(kSecAttrService)
//private let AttributeAccessGroup = String(kSecAttrAccessGroup)
//
//private let MatchLimit = String(kSecMatchLimit)
//private let MatchLimitOne = kSecMatchLimitOne
//
//private let ReturnData = String(kSecReturnData)
//
//private let ValueData = String(kSecValueData)
//
//extension Keychain {
//    
//    struct Options {
//        
//        var service = ""
//        var accessGroup: String? = nil
//
//        var query: [String: Any] {
//
//            var query = [String: Any]()
//            
//            query[ItemClass] = ItemClassGenericPassword
//            query[AttributeService] = service
//            if let accessGroup = self.accessGroup {
//                query[AttributeAccessGroup] = accessGroup
//            }
//            
//            return query
//        }
//
//    }
//    
//}
//
//extension Keychain {
//    
//    @discardableResult
//    func set(_ value: String, key: String) -> Bool {
//        guard let data = value.data(using: .utf8, allowLossyConversion: false) else {
//            logger.error("failed to convert string to data")
//            return false
//        }
//        
//        var query = options.query
//        query[AttributeAccount] = key
//        query[ValueData] = data
//
//        guard SecItemAdd(query as CFDictionary, nil) == errSecSuccess else {
//            return false
//        }
//        
//        return true
//    }
//
//    func get(_ key: String) -> String? {
//        var query = options.query
//        query[MatchLimit] = MatchLimitOne
//        query[ReturnData] = kCFBooleanTrue
//        query[AttributeAccount] = key
//
//        var result: AnyObject?
//        guard SecItemCopyMatching(query as CFDictionary, &result) == errSecSuccess else {
//            return nil
//        }
//        
//        guard let data = result as? Data else {
//            return nil
//        }
//
//        guard let string = String(data: data, encoding: .utf8) else {
//            logger.error("failed to convert data to string")
//            return nil
//        }
//
//        return string
//    }
//    
//    @discardableResult
//    func remove(_ key: String) -> Bool {
//        var query = options.query
//        query[AttributeAccount] = key
//
//        let status = SecItemDelete(query as CFDictionary)
//        if status == errSecSuccess || status == errSecItemNotFound {
//            return true
//        }
//        return false
//    }
//    
//    subscript(key: String) -> String? {
//        get {
//            get(key)
//        }
//
//        set {
//            if let value = newValue {
//                set(value, key: key)
//            } else {
//                remove(key)
//            }
//        }
//    }
//
//}
