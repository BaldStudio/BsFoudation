//
//  PropertyWrapper.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/17.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

// https://github.com/apple/swift-evolution/blob/master/proposals/0258-property-wrappers.md

// MARK: - NullResetable

@propertyWrapper
public struct NullResetable<T> {
    private var resetter: () -> T
    private var value: T?
        
    public var wrappedValue: T! {
        mutating get {
            if value == nil {
                value = resetter()
            }
            return value
        }
        set {
            value = newValue
        }
    }

    public init(wrappedValue: T!) {
        resetter = { wrappedValue }
    }
    
    public init(resetter: @autoclosure @escaping () -> T) {
        self.resetter = resetter
    }
}

// MARK: - Clamp

@propertyWrapper
public struct Clamp<T: Comparable & Numeric> {
    private var value: T
    private let range: ClosedRange<T>

    public var wrappedValue: T {
        get { value }
        set {
            value = max(range.lowerBound, newValue)
            value = min(value, range.upperBound)
        }
    }

    public init(wrappedValue value: T, _ range: ClosedRange<T>) {
        precondition(range.contains(value), "value MUST be between \(range)")
        self.value = value
        self.range = range
    }
}

// MARK: - Atomic

@propertyWrapper
final public class Atomic<T> {
    private let queue = DispatchQueue(label: "com.baldstudio.atomic")
    private var value: T

    public init(wrappedValue: T) {
        value = wrappedValue
    }

    public var wrappedValue: T {
        get {
            queue.sync { value }
        }
        set {
            queue.sync { value = newValue }
        }
    }

    public var projectedValue: Atomic<T> {
        self
    }

    public func safe(_ safety: (inout T) -> Void) {
        queue.sync {
            safety(&value)
        }
    }
}
