//
//  Bundle.swift
//  BsSwiftPlus
//
//  Created by crzorz on 2021/7/16.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import UIKit

public extension SwiftPlus where T: Bundle {
    
    @inlinable
    func info(for key: Bundle.InfoKey) -> String {
        this.infoDictionary?[key.rawValue] as? String ?? ""
    }
    
    @inlinable
    func image(_ name: String) -> UIImage? {
        UIImage(named: name, in: this, compatibleWith: nil)
    }
}

public extension Bundle {
    struct InfoKey {
        public let rawValue: String
        
        init(rawValue: String) {
            self.rawValue = rawValue
        }

        public static let id = Self(rawValue: "CFBundleIdentifier")
        public static let version = Self(rawValue: "CFBundleVersion")
        public static let shortVersion = Self(rawValue: "CFBundleShortVersionString")
        public static let name = Self(rawValue: "CFBundleName")
        public static let displayName = Self(rawValue: "CFBundleDisplayName")
        public static let executableName = Self(rawValue: "CFBundleExecutable")
        public static let copyRight = Self(rawValue: "NSHumanReadableCopyright")
    }

    @inlinable
    subscript(_ key: InfoKey) -> String {
        bs.info(for: key)
    }
}
