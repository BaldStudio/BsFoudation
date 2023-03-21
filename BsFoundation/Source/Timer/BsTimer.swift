//
//  BsTimer.swift
//  BsFoundation
//
//  Created by crzorz on 2022/12/15.
//  Copyright © 2022 BaldStudio. All rights reserved.
//

import Foundation

public final class BsTimer {
    
    private static var isInvalidated: UInt32 = 0
    
    private var timeInterval: TimeInterval = 0
    
    private weak var target: AnyObject?
    
    private var selector: Selector?
    
    private var queue: DispatchQueue!
    
    private var timer: DispatchSourceTimer!

    private var block: ((BsTimer) -> Void)?
    
    public private(set) var userInfo: Any? = nil

    public var tolerance: TimeInterval = 0 {
        didSet {
            resetTimer()
        }
    }
        
    deinit {
        invalidate()
    }
    
    public init(timeInterval: TimeInterval,
                target: AnyObject,
                selector: Selector,
                userInfo: Any? = nil,
                queue: DispatchQueue = .main) {
        self.timeInterval = timeInterval
        self.target = target
        self.selector = selector
        self.userInfo = userInfo
        initQueueAndTimer(queue)
    }

    public class func scheduled(timeInterval: TimeInterval,
                              target: AnyObject,
                              selector: Selector,
                              userInfo: Any? = nil,
                              queue: DispatchQueue = .main) -> BsTimer {
        let timer = BsTimer(timeInterval: timeInterval,
                             target: target,
                             selector: selector,
                             userInfo: userInfo,
                             queue: queue)
        timer.schedule()
        return timer
    }
    
    public init(timeInterval: TimeInterval,
                queue: DispatchQueue = .main,
                block: @escaping (BsTimer) -> Void) {
        self.timeInterval = timeInterval
        initQueueAndTimer(queue)
        self.block = block
    }

    public class func scheduled(timeInterval: TimeInterval,
                                queue: DispatchQueue = .main,
                                block: @escaping (BsTimer) -> Void) -> BsTimer {
        let timer = BsTimer(timeInterval: timeInterval,
                             queue: queue,
                             block: block)
        timer.schedule()
        return timer
    }
    
    private func initQueueAndTimer(_ targetQueue: DispatchQueue) {
        let id = Unmanaged.passUnretained(self as AnyObject).toOpaque()
        queue = DispatchQueue(label: "com.baldstudio.BsTimer.\(id)",
                              target: targetQueue)
        timer = DispatchSource.makeTimerSource(flags: .strict,
                                               queue: self.queue)
    }
    
    private func resetTimer() {
        timer.schedule(deadline: .now() + timeInterval,
                       repeating: timeInterval,
                       leeway: .nanoseconds(Int(tolerance)))
    }
    
    public func schedule() {
        resetTimer()
        timer.setEventHandler(handler: { [weak self] in
            self?.fire()
        })
        timer.resume()
    }
    
    public func fire() {
        guard OSAtomicAnd32OrigBarrier(1, &BsTimer.isInvalidated) == 0 else {
            return
        }
        
        if block == nil {
            _ = target?.perform(selector, with: self)
        }
        else {
            block!(self)
        }
    }
    
    public func invalidate() {
        if (OSAtomicAnd32OrigBarrier(7, &BsTimer.isInvalidated) != 0) {
            return
        }
        
        queue.async { [weak self] in
            self?.timer.cancel()
        }
    }

}

extension BsTimer: CustomStringConvertible {
    public var description: String {
        if block == nil {
            return "\(type(of: self)) timer=\(String(describing: timer)) timeInterval=\(timeInterval) target=\(String(describing: target)) selector=\(String(describing: selector)) userInfo=\(userInfo ?? "")"
        }
        return "\(type(of: self)) timer=\(String(describing: timer)) timeInterval=\(timeInterval) block=\(String(describing: target))"
    }
}
