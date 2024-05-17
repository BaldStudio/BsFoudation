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
    
    func slice(at idx: Int = 0, count: Int = .max) -> String {
        let i = min(count, max(idx, 0))
        let len = min(count - i, max(count, 0))
        let begin = index(startIndex, offsetBy: i)
        let end = index(begin, offsetBy: len)
        return String(self[begin..<end])
    }
    
    var isBlank: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    mutating func trimmed(_ set: CharacterSet = .whitespacesAndNewlines) {
        self = self.trimmingCharacters(in: set)
    }
}
