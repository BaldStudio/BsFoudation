//
//  Task.swift
//  BsSwiftX
//
//  Created by crzorz on 2021/7/16.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import Foundation

// MARK: -  Main

public struct MainTask {
    let mainQueue = DispatchQueue.main
    private init() {}
    
    @discardableResult
    public init(sync: Bool = false, _ block: @escaping Block) {
        if Thread.isMainThread {
            block()
            return
        }
        if sync {
            mainQueue.sync(execute: block)
        } else {
            mainQueue.async(execute: block)
        }
    }
}

// MARK: -  Delay

public struct DelayTask {
    private init() {}
    
    @discardableResult
    public init(_ seconds: TimeInterval, queue: DispatchQueue = .main, block: @escaping Block) {
        let when = DispatchTime.now() + seconds
        queue.asyncAfter(deadline: when) {
            block()
        }
    }
}

// MARK: -  Once

// https://gist.github.com/nil-biribiri/67f158c8a93ff0a5d8c99ff41d8fe3bd
public struct OnceTask {
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
        guard !OnceTask.pocket.contains(token) else { return }
        OnceTask.pocket.append(token)
        block()
    }
}

// MARK: -  debounce & throttle

public class DebounceTask {
    private var workItem: DispatchWorkItem?
    private let queue: DispatchQueue
    private let delay: TimeInterval
    
    public required init(queue: DispatchQueue = DispatchQueue.main, delay: TimeInterval) {
        self.queue = queue
        self.delay = delay
    }
    
    public func execute(action: @escaping () -> Void) {
        // 取消以前的工作
        workItem?.cancel()
        
        // 创建新的工作
        workItem = DispatchWorkItem(block: action)
        
        // 延迟执行新的工作
        if let workItem = workItem {
            queue.asyncAfter(deadline: .now() + delay, execute: workItem)
        }
    }
}

public class ThrottleTask {
    private var workItem: DispatchWorkItem?
    private let queue: DispatchQueue
    private let interval: TimeInterval
    private var lastRun: Date?
    
    public required init(queue: DispatchQueue = DispatchQueue.main, interval: TimeInterval) {
        self.queue = queue
        self.interval = interval
    }
    
    public func execute(action: @escaping () -> Void) {
        // 取消以前的工作
        workItem?.cancel()
        
        // 确定上次执行时间
        let now = Date()
        if let lastRun = lastRun, now.timeIntervalSince(lastRun) < interval {
            // 创建新的工作，在剩余时间结束后执行
            workItem = DispatchWorkItem(block: action)
            if let workItem = workItem {
                queue.asyncAfter(deadline: .now() + interval - now.timeIntervalSince(lastRun), execute: workItem)
            }
        } else {
            // 立即执行
            workItem = DispatchWorkItem(block: action)
            if let workItem = workItem {
                queue.async(execute: workItem)
            }
        }
        
        // 更新上次执行时间
        lastRun = now
    }
}
