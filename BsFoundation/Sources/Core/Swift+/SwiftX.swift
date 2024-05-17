//
//  SwiftX.swift
//  BsFoundation
//
//  Created by crzorz on 2020/9/27.
//  Copyright © 2020 BaldStudio. All rights reserved.
//

import Foundation

public struct BaldStudio<T> {
    public static var this: T.Type {
        T.self
    }
    public var this: T
}

public protocol SwiftCompatible {
    associatedtype CompatibleType
    static var bs: BaldStudio<CompatibleType>.Type { get set }
    var bs: BaldStudio<CompatibleType> { get set }

}

public extension SwiftCompatible {
    static var bs: BaldStudio<Self>.Type {
        get { BaldStudio<Self>.self }
        set {}
    }

    var bs: BaldStudio<Self> {
        get { BaldStudio(this: self) }
        set {}
    }
}

extension NSObject: SwiftCompatible {}
