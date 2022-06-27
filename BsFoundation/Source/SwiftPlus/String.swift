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
    
    @inlinable
    var trimmed: String {
        this.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// 从 idx 截取至末尾
    @inlinable
    func slice(at idx: Int) -> String {
        String(this.suffix(this.count - idx))
    }
    
    /// 从 idx 截取至 idx + count
    func slice(at idx: Int = 0, count: Int) -> String {
        let begin = this.index(this.startIndex,
                               offsetBy: idx)
        let end = this.index(this.startIndex,
                             offsetBy: idx + count)
        return String(this[begin..<end])
    }
    
}
