//
//  Logger.swift
//  BsFoundation
//
//  Created by crzorz on 2021/7/21.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import os

struct BsLog {
//    private let _logger = OSLog(subsystem: "com.bald-studio.BsFoundation", category: "BsFoundation")
    @available(iOS 14.0, *)
    private static let _logger = Logger(subsystem: "com.bald-studio.BsFoundation", category: "BsFoundation")

    static func debug(_ log: String) {
        if #available(iOS 14.0, *) {
            _logger.debug("\(log)")
        }
    }
    
}
