//
//  PropertyWrapper.swift
//  BsFoundation
//
//  Created by crzorz on 2021/12/7.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import Foundation

//MARK: - Clamp

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

//MARK: - Lazy

@propertyWrapper
public struct Lazy<T> {
    private var closure: () -> T
    private var value: T?
    
    public init(default value: @autoclosure @escaping () -> T) {
        closure = value
    }
    
    public init(body value: @escaping () -> T) {
        closure = value
    }

    public var wrappedValue: T? {
        mutating get {
            if value == nil {
                value = closure()
            }
            
            return value
        }
        set {
            value = newValue
        }
    }
}
