//
//  Data.swift
//  BsSwiftX
//
//  Created by crzorz on 2021/8/27.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import Foundation

public extension SwiftX where T == Data {
    
    @inlinable
    var bytes: [UInt8] {
        [UInt8](this)
    }
    
}

public extension Data {
    @inlinable
    mutating func append<E: Numeric>(_ value: E) {
        Swift.withUnsafeBytes(of: value) { append(contentsOf: $0) }
    }
}
