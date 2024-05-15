//
//  Collection.swift
//  BsFoundation
//
//  Created by crzorz on 2021/11/3.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import Foundation

public extension Collection {
    
    @inlinable
    subscript (safe index: Self.Index) -> Iterator.Element? {
        (startIndex ..< endIndex).contains(index) ? self[index] : nil
    }
}
