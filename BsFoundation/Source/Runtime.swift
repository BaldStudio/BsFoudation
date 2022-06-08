//
//  Runtime.swift
//  BsFoundation
//
//  Created by crzorz on 2021/9/3.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import Foundation

public protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    
    @inlinable
    public var isNil: Bool {
        self == nil
    }
}
