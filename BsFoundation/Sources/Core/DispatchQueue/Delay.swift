//
//  Delay.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/28.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

public struct Delay {
    private init() {}
    
    @discardableResult
    public init(_ seconds: TimeInterval, queue: DispatchQueue = .main, block: @escaping Block) {
        let when = DispatchTime.now() + seconds
        queue.asyncAfter(deadline: when) {
            block()
        }
    }
}
