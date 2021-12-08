//
//  PropertyWrapper.swift
//  BsFoundation
//
//  Created by crzorz on 2021/12/7.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import Foundation

@propertyWrapper
public struct Restrict<T: Comparable & Numeric> {
    var value: T = 0

    let minimum: T
    let maximum: T
    
    public var wrappedValue: T {
        get { value }
        set {
            precondition(minimum < maximum, "ERROR> minimum MUST less than maximum")
            
            value = max(minimum, newValue)
            value = min(maximum, value)
        }
    }
    
    public init(min: T, max: T) {
        minimum = min
        maximum = max
    }

}
