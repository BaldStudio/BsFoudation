//
//  BsLogger.swift
//  BsFoundation
//
//  Created by crzorz on 2021/7/21.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import os

public struct BsLogger {
    var subsystem: String
    var category: String
    
    @available(iOS 14.0, *)
    private static var _logger: Logger!
    
    public init(subsystem: String, category: String) {
        self.subsystem = subsystem
        self.category = category
        if #available(iOS 14.0, *) {
            Self._logger = Logger(subsystem: subsystem, category: category)
        }
    }
    
    public func debug(_ log: String) {
        if #available(iOS 14.0, *) {
            Self._logger.debug("\(log)")
        }
        else {
            print(log)
        }
    }
}
