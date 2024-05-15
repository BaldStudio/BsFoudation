//
//  BsFoundation.swift
//  BsFoundation
//
//  Created by crzorz on 2021/8/4.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

@_exported import UIKit
@_exported import BsLogging

let logger = Logger(label: "BsFoundation")

public func hasDefined(_ macro: String) -> Bool {
    
    if macro == "DEBUG" {
#if DEBUG
        return true
#else
        return false
#endif
    }
    
    return false
}
