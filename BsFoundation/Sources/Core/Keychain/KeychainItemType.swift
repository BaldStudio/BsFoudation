//
//  KeychainItemType.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/31.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

extension Keychain {
    public enum ItemType {
        /// The value that indicates a Generic password item.
        ///
        /// For more information, see [Keychain Services](https://developer.apple.com/documentation/security/ksecclassgenericpassword)
        case genericPassword

        /// The value that indicates an Internet password item.
        ///
        /// For more information, see [Keychain Services](https://developer.apple.com/documentation/security/ksecclassinternetpassword)
        case internetPassword
        
        init?(rawValue: CFString) {
            switch rawValue {
                case kSecClassGenericPassword:
                    self = .genericPassword
                case kSecClassInternetPassword:
                    self = .internetPassword
                default:
                    return nil
            }
        }

        var rawValue: CFString {
            switch self {
                case .genericPassword:
                    return kSecClassGenericPassword
                case .internetPassword:
                    return kSecClassInternetPassword
            }
        }
    }
}
