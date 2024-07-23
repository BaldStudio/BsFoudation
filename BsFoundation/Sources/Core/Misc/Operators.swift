//
//  Operators.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/7/24.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

// MARK: -  ?=

infix operator ?=
/// 将  a = a ?? b 简化为 a ?= b
public func ?= <T>(lhs: inout T?, rhs: @autoclosure () -> T) {
    if lhs == nil {
        lhs = rhs()
    }
}
