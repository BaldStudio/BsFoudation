//
//  C.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/7/10.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

public func size<T>(of value: T) -> Int {
    MemoryLayout.size(ofValue: value)
}

// MARK: -  UnsafeRawPointer

public extension UnsafeRawPointer {
    func cast<Out>() -> Out {
        bindMemory(to: Out.self, capacity: 1).pointee
    }
}

