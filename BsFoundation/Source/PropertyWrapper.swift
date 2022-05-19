//
//  PropertyWrapper.swift
//  BsFoundation
//
//  Created by crzorz on 2021/12/7.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import Foundation

@propertyWrapper
public struct Clamp<T: Comparable & Numeric> {
    var value: T
    let range: ClosedRange<T>

    public init(wrappedValue value: T, _ range: ClosedRange<T>) {
        precondition(range.contains(value), "value MUST be between \(range)")
        self.value = value
        self.range = range
    }

    public var wrappedValue: T {
        get { value }
        set { value = min(max(range.lowerBound, newValue), range.upperBound) }
    }
}
