//
//  TargetConditionals.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/16.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

public enum BuildTarget {
    case DEBUG
}

public func hasDefined(_ macro: BuildTarget) -> Bool {
#if DEBUG
    if macro == .DEBUG {
        return true
    }
#endif
    return false
}
