//
//  Data+.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/16.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

public extension Data {
    @inlinable
    var bytes: [UInt8] {
        [UInt8](self)
    }
    
    @inlinable
    mutating func append<E: Numeric>(_ value: E) {
        Swift.withUnsafeBytes(of: value) { append(contentsOf: $0) }
    }
}
