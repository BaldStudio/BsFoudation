//
//  Bundle.swift
//  BsSwiftPlus
//
//  Created by crzorz on 2021/7/16.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import Foundation

public extension SwiftPlus where T: Bundle {
    static func info(for key: InfoKey, of bundle: Bundle = .main) -> String {
        return bundle.infoDictionary?[key.rawValue] as? String ?? ""
    }
    
    struct InfoKey {
        public var rawValue: String
        
        public static var id: InfoKey { InfoKey(rawValue: "CFBundleIdentifier")}
        public static var version: InfoKey { InfoKey(rawValue: "CFBundleVersion") }
        public static var shortVersion: InfoKey { InfoKey(rawValue: "CFBundleShortVersionString") }
        public static var name: InfoKey { InfoKey(rawValue: "CFBundleName") }
        public static var displayName: InfoKey { InfoKey(rawValue: "CFBundleDisplayName") }
        public static var execName: InfoKey { InfoKey(rawValue: "CFBundleExecutable") }
        public static var copyRight: InfoKey{ InfoKey(rawValue: "NSHumanReadableCopyright") }
        
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
    
}
