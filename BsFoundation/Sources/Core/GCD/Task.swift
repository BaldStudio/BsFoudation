//
//  Task.swift
//  BsSwiftX
//
//  Created by crzorz on 2021/7/16.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import Foundation

// MARK: -  Async

/// 异步任务，会根据当前线程是否为主线程做处理，强制异步执行
public struct AsyncTask {
    private init() {}
    
    @discardableResult
    public init(queue: DispatchQueue = .global(), _ block: @escaping Block) {
        if Thread.isMainThread {
            queue.async(execute: block)
        } else {
            block()
        }
    }
}


// MARK: -  Main

/// 主线程任务，会根据当前线程是否为主线程做处理，强制切换到主线程执行，支持 async 和 sync
public struct MainTask {
    private let mainQueue = DispatchQueue.main
    private init() {}
    
    @discardableResult
    public init(sync: Bool = false, _ block: @escaping Block) {
        if sync {
            if Thread.isMainThread {
                block()
            } else {
                mainQueue.sync(execute: block)
            }
        } else {
            mainQueue.async(execute: block)
        }
    }
}

// MARK: -  Delay

/// 延迟任务
public struct DelayTask {
    private init() {}
    
    @discardableResult
    public init(_ seconds: TimeInterval, queue: DispatchQueue = .main, block: @escaping Block) {
        let when = DispatchTime.now() + seconds
        queue.asyncAfter(deadline: when, execute: block)
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
        workItem?.cancel()
        workItem = DispatchWorkItem(block: action)
        if let workItem {
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
        workItem?.cancel()
        let now = Date()
        if let lastRun, now.timeIntervalSince(lastRun) < interval {
            workItem = DispatchWorkItem(block: action)
            if let workItem {
                queue.asyncAfter(deadline: .now() + interval - now.timeIntervalSince(lastRun), execute: workItem)
            }
        } else {
            workItem = DispatchWorkItem(block: action)
            if let workItem {
                queue.async(execute: workItem)
            }
        }
        lastRun = now
    }
}
