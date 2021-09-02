//
//  DispatchQueue.swift
//  BsSwiftPlus
//
//  Created by crzorz on 2021/7/16.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import Foundation

// MARK: - debounce

public extension SwiftPlus where T: DispatchQueue {
    // http://stackoverflow.com/questions/27116684/how-can-i-debounce-a-method-call
    func debounce(delay: Double, action: @escaping Closure.primary) -> Closure.primary {
        var lastFireTime = DispatchTime.now()
        let deadline = { lastFireTime + delay }
        return {
            this.asyncAfter(deadline: deadline()) {
                let now = DispatchTime.now()
                if now >= deadline() {
                    lastFireTime = now
                    action()
                }
            }
        }
    }
}

// MARK: - once

private var _onceTracker: [String] = []

// https://gist.github.com/nil-biribiri/67f158c8a93ff0a5d8c99ff41d8fe3bd
public extension SwiftPlus where T: DispatchQueue {
    
    /**
     Executes a block of code, associated with a auto generate unique token by file name + fuction name + line of code, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
    */
    static func once(file: String = #file,
                     function: String = #function,
                     line: Int = #line,
                     block: Closure.primary) {
        let token = "\(file):\(function):\(line)"
        once(token: token, block: block)
    }

    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    static func once(token: String, block: Closure.primary) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }

        guard !_onceTracker.contains(token) else { return }

        _onceTracker.append(token)
        block()
    }

}
