//
//  Bundle+.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/16.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

public extension Bundle {
    struct InfoKey {
        public let rawValue: String
        
        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public static let id = InfoKey(rawValue: "CFBundleIdentifier")
        public static let version = InfoKey(rawValue: "CFBundleShortVersionString")
        public static let build = InfoKey(rawValue: "CFBundleVersion")
        public static let name = InfoKey(rawValue: "CFBundleName")
        public static let displayName = InfoKey(rawValue: "CFBundleDisplayName")
        public static let executableName = InfoKey(rawValue: "CFBundleExecutable")
        public static let copyright = InfoKey(rawValue: "NSHumanReadableCopyright")
    }
    
    @inlinable
    subscript(_ key: InfoKey) -> String {
        info(for: key)
    }
    
    @inlinable
    var info: [String : Any] {
        infoDictionary ?? [:]
    }
    
    func info(for key: Bundle.InfoKey) -> String {
        info[key.rawValue] as? String ?? ""
    }

}

