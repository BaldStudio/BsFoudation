//
//  Manifest.swift
//  BsFoundation
//
//  Created by crzorz on 2021/7/21.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import Foundation

public struct Manifest {
    public struct Key: Hashable {
        public var rawValue: String
        
        public static let name: Key = Key( "name")
        public static let id: Key = Key("id")
        public static let version: Key = Key("version")

        public init(_ rawValue: String) {
            self.rawValue = rawValue
        }
    }
    
    public var name: String
    public var id: String
    public var version: String

    public init(_ info: [Key: String]) {
        name = info[.name] ?? "unknown"
        id = info[.id] ?? ""
        version = info[.version] ?? "0.0.0"
    }
}
