//
//  Once.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/28.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

// https://gist.github.com/nil-biribiri/67f158c8a93ff0a5d8c99ff41d8fe3bd

public struct Once {
    private static var pocket: [String] = []
    private init() {}

    @discardableResult
    public init(file: String = #file, function: String = #function, line: Int = #line, block: Block) {
        let token = "\(file):\(function):\(line)"
        self.init(token: token, block: block)
    }
    
    @discardableResult
    public init(token: String, block: Block) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        guard !Once.pocket.contains(token) else { return }
        Once.pocket.append(token)
        block()
    }
}
