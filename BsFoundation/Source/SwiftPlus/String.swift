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
    var toURL: URL? {
        URL(string: this)
    }
        
    /// 从 idx 截取至 idx + count，默认会截取到末尾
    func slice(at idx: Int = 0, count: Int = .max) -> String {
        let i = min(this.count, max(idx, 0))
        let len = min(this.count - i, max(count, 0))
        let begin = this.index(this.startIndex,
                               offsetBy: i)
        let end = this.index(begin,
                             offsetBy: len)
        return String(this[begin..<end])
    }
    
}
