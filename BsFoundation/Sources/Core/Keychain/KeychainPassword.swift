//
//  Password.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/31.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

// MARK: -  Generic Password

extension Keychain {
    public struct GenericPassword {
        public let key: String

        /// The service associated with Keychain item
        public var service: String = Bundle.main.bundleIdentifier!

        /// Indicates when your app has access to the data in a Keychain item
        public var accessible: AccessibilityLevel

        /// Indicates whether the item in question is synchronized to other devices through iCloud
        ///
        /// For more information, see [Keychain Services](https://developer.apple.com/documentation/security/ksecattrsynchronizable/)
        public var synchronizable: Bool

        /// The user-visible label for this item
        ///
        /// For more information, see [Keychain Services](https://developer.apple.com/documentation/security/ksecattrlabel)
        public let label: String?

        /// The comment associated with the item
        ///
        /// For more information, see [Keychain Services](https://developer.apple.com/documentation/security/ksecattrcomment)
        public let comment: String?

        /// The item's description
        ///
        /// For more information, see [Keychain Services](https://developer.apple.com/documentation/security/ksecattrcomment)
        public let description: String?

        /// Indicating the item's visibility
        ///
        /// iOS does not have a general-purpose way to view keychain items, so this propery make sense only with sync
        /// to a Mac via iCloud Keychain, than you might want to make it invisible there.
        ///
        /// For more information, see [Keychain Services](https://developer.apple.com/documentation/security/ksecattrisinvisible)
        public let isInvisible: Bool?

        /// Indicating whether the item has a valid password
        ///
        /// This is useful if your application doesn't want a password for some particular service to be stored in the keychain,
        /// but prefers that it always be entered by the user.
        ///
        /// For more information, see [Keychain Services](https://developer.apple.com/documentation/security/ksecattrisnegative)
        public let isNegative: Bool?

        /// TBD
        public let generic: Data?

        /// Indicating  the item's creator attribute
        ///
        /// You use this key to set or get a value of type CFNumberRef that represents the item's creator.
        /// This number is the unsigned integer representation of a four-character code (e.g., 'aCrt').
        ///
        /// For more information, see [Keychain Services](https://developer.apple.com/documentation/security/ksecattrcreator)
        public let creator: String?

        /// Indicating the type of secret associated with the query
        ///
        /// You use this key to set or get a value of type CFNumberRef that represents the item's type.
        /// This number is the unsigned integer representation of a four-character code (e.g., 'aTyp').
        ///
        /// For more information, see [Keychain Services](https://developer.apple.com/documentation/security/ksecattrtype)
        public let type: String?
    }
}

// MARK: -  Internet Password

extension Keychain {
    public struct InternetPassword {
        public let key: String

        /// Indicates when your app has access to the data in a Keychain item
        public var accessible: AccessibilityLevel

        /// Indicates whether the item in question is synchronized to other devices through iCloud
        ///
        /// For more information, see [Keychain Services](https://developer.apple.com/documentation/security/ksecattrsynchronizable/)
        public var synchronizable: Bool

        /// Exclusive Internet Password attribuite
        /// Extracted from URL attributes:
        /// * `Server` - the server's domain name or IP address,
        /// * `Path` - the path component of the URL,
        /// * `Port` - the port number
        /// * `Protocol`- the protocol
        public var url: URL

        // TODO: extract scheme from URL, but temporarily provide explicit
        public var scheme: ProtocolType

        /// Exclusive Internet Password attribuite
        public var authentication: AuthenticationType

        /// Exclusive Internet Password attribuite
        public var securityDomain: String?

        /// The user-visible label for this item
        ///
        /// For more information, see [Keychain Services](https://developer.apple.com/documentation/security/ksecattrlabel)
        public let label: String?

        /// The comment associated with the item
        ///
        /// For more information, see [Keychain Services](https://developer.apple.com/documentation/security/ksecattrcomment)
        public let comment: String?

        /// The item's description
        ///
        /// For more information, see [Keychain Services](https://developer.apple.com/documentation/security/ksecattrcomment)
        public let description: String?

        /// Indicating the item's visibility
        ///
        /// iOS does not have a general-purpose way to view keychain items, so this propery make sense only with sync
        /// to a Mac via iCloud Keychain, than you might want to make it invisible there.
        ///
        /// For more information, see [Keychain Services](https://developer.apple.com/documentation/security/ksecattrisinvisible)
        public let isInvisible: Bool?

        /// Indicating whether the item has a valid password
        ///
        /// This is useful if your application doesn't want a password for some particular service to be stored in the keychain,
        /// but prefers that it always be entered by the user.
        ///
        /// For more information, see [Keychain Services](https://developer.apple.com/documentation/security/ksecattrisnegative)
        public let isNegative: Bool?

        /// Indicating  the item's creator attribute
        ///
        /// You use this key to set or get a value of type CFNumberRef that represents the item's creator.
        /// This number is the unsigned integer representation of a four-character code (e.g., 'aCrt').
        ///
        /// For more information, see [Keychain Services](https://developer.apple.com/documentation/security/ksecattrcreator)
        public let creator: String?

        /// Indicating the type of secret associated with the query
        ///
        /// You use this key to set or get a value of type CFNumberRef that represents the item's type.
        /// This number is the unsigned integer representation of a four-character code (e.g., 'aTyp').
        ///
        /// For more information, see [Keychain Services](https://developer.apple.com/documentation/security/ksecattrtype)
        public let type: String?
    }
}
