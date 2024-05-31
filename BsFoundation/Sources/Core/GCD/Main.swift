//
//  Main.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/31.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

public struct Main {
    private init() {}
    
    @discardableResult
    public init(sync: Bool = false, _ block: @escaping Block) {
        if Thread.isMainThread {
            block()
            return
        }
        if sync {
            DispatchQueue.main.sync(execute: block)
        } else {
            DispatchQueue.main.async(execute: block)
        }
    }
}
