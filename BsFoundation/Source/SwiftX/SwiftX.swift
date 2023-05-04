//
//  SwiftX.swift
//  SwiftX
//
//  Created by crzorz on 2020/9/27.
//  Copyright © 2020 BaldStudio. All rights reserved.
//

import Foundation

public struct SwiftX<T> {
    public static var this: T.Type {
        T.self
    }
    public var this: T
}

public protocol SwiftCompatible {
    associatedtype CompatibleType
    static var bs: SwiftX<CompatibleType>.Type { get set }
    var bs: SwiftX<CompatibleType> { get set }

}

public extension SwiftCompatible {
    static var bs: SwiftX<Self>.Type {
        get { SwiftX<Self>.self }
        set {}
    }

    var bs: SwiftX<Self> {
        get { SwiftX(this: self) }
        set {}
    }
}

extension NSObject: SwiftCompatible {}
extension String: SwiftCompatible {}
extension Data: SwiftCompatible {}

