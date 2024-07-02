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
        self == nil
    }

    public var isNotNil: Bool {
        self != nil
    }
}

infix operator ?=
/// 将  a = a ?? b 简化为 a ?= b
public func ?= <T>(lhs: inout T?, rhs: @autoclosure BlockR<T>) {
    if lhs == nil {
        lhs = rhs()
    }
}
