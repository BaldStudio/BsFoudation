//
//  String+.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/16.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

public extension String {
    @inlinable
    var asURL: URL? {
        URL(string: self)
    }
    
    @inlinable
    var isNotEmpty: Bool {
        !isEmpty
    }
}
