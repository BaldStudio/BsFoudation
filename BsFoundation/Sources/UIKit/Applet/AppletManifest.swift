//
//  AppletManifest.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/30.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

public extension Applet {
    struct Manifest {
        public let name: String
        public let bundle: String
        
        public init(name: String,
                    bundle: String) {
            self.name = name
            self.bundle = bundle
        }
        
        var appletClass: Applet.Type? {
            NSClassFromString("\(bundle).\(name)") as? Applet.Type
        }
    }
}

extension Applet.Manifest: CustomStringConvertible {
    public var description: String {
        String(format: "\(bundle).\(name)")
    }
}

