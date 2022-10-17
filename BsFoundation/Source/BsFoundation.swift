//
//  BsFoundation.swift
//  BsFoundation
//
//  Created by crzorz on 2021/8/4.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import Foundation

let logger: BsLogger = {
    let logger = BsLogger(subsystem: "com.bald-studio.BsFoundation",
                          category: "BsFoundation")
    logger.level = .none
    return logger
}()

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
