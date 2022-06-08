//
//  SwiftPlus.swift
//  SwiftPlus
//
//  Created by crzorz on 2020/9/27.
//  Copyright © 2020 BaldStudio. All rights reserved.
//

import Foundation

public struct SwiftPlus<T> {
    @usableFromInline
    static var this: T.Type {
        T.self
    }

    @usableFromInline
    var this: T
}

public protocol SwiftCompatible {
    associatedtype T
    var bs: T { get }
    static var bs: T.Type { get }
}

public extension SwiftCompatible {
    var bs: SwiftPlus<Self> {
        SwiftPlus(this: self)
    }
    
    static var bs: SwiftPlus<Self>.Type {
        SwiftPlus<Self>.self
    }
}

extension NSObject: SwiftCompatible {}
extension String: SwiftCompatible {}
extension Data: SwiftCompatible {}

