//
//  GCDTimer.swift
//  BsFoundation
//
//  Created by crzorz on 2022/12/15.
//  Copyright © 2022 BaldStudio. All rights reserved.
//

import Foundation

public class GCDTimer {
    
    private static var isInvalidated: Int32 = 0
    
    private var timeInterval: TimeInterval = 0
    
    private weak var target: AnyObject?
    
    private var selector: Selector
    
    open private(set) var userInfo: Any? = nil

    private var repeats = true
    
    private var queue: DispatchQueue
    private var timer: DispatchSourceTimer

    public var tolerance: TimeInterval = 0 {
        didSet {
            resetTimer()
        }
    }
        
    deinit {
        invalidate()
    }
    
    public required init(timeInterval: TimeInterval,
                         target: AnyObject,
                         selector: Selector,
                         userInfo: Any? = nil,
                         repeats: Bool = true,
                         queue: DispatchQueue = .main) {
        self.timeInterval = timeInterval
        self.target = target
        self.selector = selector
        self.userInfo = userInfo
        self.repeats = repeats
        
        if (queue == .main) {
            self.queue = queue
        }
        else {
            let queueName = "com.baldstudio.gcdtimer"
            self.queue = DispatchQueue(label: queueName)
            self.queue.setTarget(queue: queue)
        }

        timer = DispatchSource.makeTimerSource(flags: .strict,
                                               queue: self.queue)
    }

    public class func scheduled(timeInterval: TimeInterval,
                              target: AnyObject,
                              selector: Selector,
                              userInfo: Any? = nil,
                              repeats: Bool = true,
                              queue: DispatchQueue = .main) -> Self {
        let timer = Self.init(timeInterval: timeInterval,
                              target: target,
                              selector: selector,
                              userInfo: userInfo,
                              repeats: repeats,
                              queue: queue)
        timer.schedule()
        return timer
    }
    
//    public init(timeInterval: TimeInterval,
//                repeats: Bool,
//                queue: DispatchQueue = .main,
//                block: @escaping @Sendable (Self) -> Void) {
//
//    }
//
//    public class func scheduled(timeInterval: TimeInterval,
//                              repeats: Bool,
//                              queue: DispatchQueue = .main,
//                              block: @escaping @Sendable (Self) -> Void) -> Self {
//
//    }
    
    private func resetTimer() {
        timer.schedule(deadline: .now() + timeInterval,
                       repeating: timeInterval,
                       leeway: .nanoseconds(Int(tolerance)))
    }
    
    private func schedule() {
        resetTimer()
        timer.setEventHandler(handler: { [weak self] in
            self?.fire()
        })
        timer.resume()
    }
    
    public func fire() {
        guard OSAtomicAnd32OrigBarrier(1, &Self.isInvalidated) == 0 else {
            return
        }
        
        _ = target?.perform(selector, with: target)
        
        if !repeats {
            invalidate()
        }
    }
    
    public func invalidate() {
        if (OSAtomicAnd32OrigBarrier(7, &Self.isInvalidated) != 0) {
            return
        }
        
        queue.async { [weak self] in
            self?.timer.cancel()
        }
        
    }

}

extension GCDTimer: CustomStringConvertible {
    public var description: String {
        "\(self) timeInterval=\(timeInterval) target=\(String(describing: target)) selector=\(selector) userInfo=\(userInfo ?? "") repeats=\(repeats) timer=\(timer)"
    }
}
