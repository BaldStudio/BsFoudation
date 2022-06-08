//
//  String.swift
//  BsSwiftPlus
//
//  Created by crzorz on 2021/7/16.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import Foundation

public extension SwiftPlus where T == String {
    
    @inlinable
    var url: URL? {
        URL(string: this)
    }
    
    @inlinable
    var trimmed: String {
        this.trimmingCharacters(in: .whitespacesAndNewlines)
    }

}
