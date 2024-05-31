//
//  KeychainAccessibilityLevel.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/31.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

extension Keychain {
    public enum AccessibilityLevel {
        /// The data in the keychain can only be accessed when the device is unlocked.
        /// Only available if a passcode is set on the device
        ///
        ///  For more information, see [Keychain Services](https://developer.apple.com/documentation/security/ksecattraccessiblewhenpasscodesetthisdeviceonly)
        case whenPasscodeSetThisDeviceOnly

        /// The data in the keychain item can be accessed only while the device is unlocked by the user.
        case unlockedThisDeviceOnly

        /// The data in the keychain item can be accessed only while the device is unlocked by the user.
        case whenUnlocked

        /// The data in the keychain item cannot be accessed after a restart until the device has been unlocked once by the user.
        case afterFirstUnlockThisDeviceOnly

        /// The data in the keychain item cannot be accessed after a restart until the device has been unlocked once by the user.
        case afterFirstUnlock
        
        init?(rawValue: CFString) {
            switch rawValue {
                case kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly:
                    self = .whenPasscodeSetThisDeviceOnly
                case kSecAttrAccessibleWhenUnlockedThisDeviceOnly:
                    self = .unlockedThisDeviceOnly
                case kSecAttrAccessibleWhenUnlocked:
                    self = .whenUnlocked
                case kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly:
                    self = .afterFirstUnlockThisDeviceOnly
                case kSecAttrAccessibleAfterFirstUnlock:
                    self = .afterFirstUnlock
                default:
                    return nil
            }
        }

        var rawValue: CFString {
            switch self {
                case .whenPasscodeSetThisDeviceOnly:
                    return kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly
                case .unlockedThisDeviceOnly:
                    return kSecAttrAccessibleWhenUnlockedThisDeviceOnly
                case .whenUnlocked:
                    return kSecAttrAccessibleWhenUnlocked
                case .afterFirstUnlockThisDeviceOnly:
                    return kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
                case .afterFirstUnlock:
                    return kSecAttrAccessibleAfterFirstUnlock
            }
        }
    }
}
