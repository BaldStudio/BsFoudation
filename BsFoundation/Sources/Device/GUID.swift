//
//  GUID.swift
//  BsDevice
//
//  Created by crzorz on 2022/8/25.
//  Copyright © 2022 BaldStudio. All rights reserved.
//

import Foundation

public struct GUID {
    
    public enum KeepMode {
        case none
        case memory
        case disk
//        case keychain
    }
    
    private static var storeKey = "com.baldstudio.BsDevice"
    
    private static var stringValue = ""
    
//    private static let keychain = Keychain()
    
    private static var systemUUID: String {
        UUID().uuidString
    }
    
    public static let shared = GUID()
    
    public static func generate(mode: KeepMode = .none) -> String {
        switch mode {
        case .none:
            return systemUUID
        case .memory:
            if stringValue.isEmpty {
                stringValue = systemUUID
            }
            return stringValue
        case .disk:
            var value: String! = UserDefaults.standard.string(forKey: storeKey)
            if value == nil && value.isEmpty {
                value = systemUUID
                UserDefaults.standard.set(value, forKey: storeKey)
            }
            return value
//        case .keychain:
//            var value: String! = keychain["UDID"]
//            if value == nil {
//                value = systemUUID
//                keychain["UDID"] = value
//            }
//            return value
        }
    }

}
