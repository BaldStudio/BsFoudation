//
//  Optional+.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/16.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

public protocol AnyOptional {
    var isNil: Bool { get }
    var isNotNil: Bool { get }
}

extension Optional: AnyOptional {
    public var isNil: Bool {
        // TODO: Optional嵌套问题
        self == nil
    }

    public var isNotNil: Bool {
        !isNil
    }
}
