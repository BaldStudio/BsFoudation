//
//  Data.swift
//  BsSwiftPlus
//
//  Created by crzorz on 2021/8/27.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import Foundation

public extension SwiftPlus where T == Data {
    
    @inlinable
    var bytes: [UInt8] {
        [UInt8](this)
    }
    
}
