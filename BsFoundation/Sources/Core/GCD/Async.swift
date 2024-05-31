//
//  Async.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/20.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

// MARK: -  GCD enum

private enum GCD {
    case main, userInteractive, userInitiated, utility, background, custom(queue: DispatchQueue)
    
    var queue: DispatchQueue {
        switch self {
            case .main: return .main
            case .userInteractive: return .global(qos: .userInteractive)
            case .userInitiated: return .global(qos: .userInitiated)
            case .utility: return .global(qos: .utility)
            case .background: return .global(qos: .background)
            case .custom(let queue): return queue
        }
    }
}

// MARK: -  Async

private class _Reference<T> {
    var value: T?
}

public typealias Async = AsyncBlock<Void, Void>

public struct AsyncBlock<Input, Output> {
    private let input: _Reference<Input>?
    private let output: _Reference<Output>
    private let block: DispatchWorkItem

    public var value: Output? { output.value }
    
    private init(input: _Reference<Input>? = nil,
                 output: _Reference<Output> = _Reference(),
                 _ block: DispatchWorkItem) {
        self.block = block
        self.input = input
        self.output = output
    }
    
    @discardableResult
    public init(_ block: @escaping Block) where Input == Void, Output == Void {
        input = nil
        
        let output = _Reference<Void>()
        let block = DispatchWorkItem(block: {
            output.value = block()
        })
        let queue = GCD.custom(queue: .global()).queue
        queue.async(execute: block)
        
        self.output = output
        self.block = block
    }
}

// MARK: -  Static Methods

public extension AsyncBlock {
    @discardableResult
    static func main<R>(after seconds: TimeInterval? = nil,
                             _ block: @escaping () -> R) -> AsyncBlock<Void, R> {
        AsyncBlock.async(queue: .main, after: seconds, block: block)
    }
    
    @discardableResult
    static func userInteractive<R>(after seconds: TimeInterval? = nil,
                                        _ block: @escaping () -> R) -> AsyncBlock<Void, R> {
        AsyncBlock.async(queue: .userInteractive, after: seconds, block: block)
    }
    
    @discardableResult
    static func userInitiated<R>(after seconds: TimeInterval? = nil,
                                      _ block: @escaping () -> R) -> AsyncBlock<Void, R> {
        AsyncBlock.async(queue: .userInitiated, after: seconds, block: block)
    }
    
    @discardableResult
    static func utility<R>(after seconds: TimeInterval? = nil,
                                _ block: @escaping () -> R) -> AsyncBlock<Void, R> {
        AsyncBlock.async(queue: .utility, after: seconds, block: block)
    }
    
    @discardableResult
    static func background<R>(after seconds: TimeInterval? = nil,
                                   _ block: @escaping () -> R) -> AsyncBlock<Void, R> {
        AsyncBlock.async(queue: .background, after: seconds, block: block)
    }
    
    @discardableResult
    static func custom<R>(queue: DispatchQueue,
                               after seconds: TimeInterval? = nil,
                               _ block: @escaping () -> R) -> AsyncBlock<Void, R> {
        AsyncBlock.async(queue: .custom(queue: queue), after: seconds, block: block)
    }
    
    private static func async<R>(queue: GCD,
                                      after seconds: TimeInterval? = nil,
                                      block: @escaping () -> R) -> AsyncBlock<Void, R> {
        let output = _Reference<R>()
        let block = DispatchWorkItem(block: {
            output.value = block()
        })
        
        let queue = queue.queue
        if let seconds {
            let time = DispatchTime.now() + seconds
            queue.asyncAfter(deadline: time, execute: block)
        } else {
            queue.async(execute: block)
        }

        return AsyncBlock<Void, R>(output: output, block)
    }
}

// MARK: -  Chain

public extension AsyncBlock {
    @discardableResult
    func main<R>(after seconds: TimeInterval? = nil,
                      _ block: @escaping (Output) -> R) -> AsyncBlock<Output, R> {
        chain(queue: .main, after: seconds, block: block)
    }
    
    @discardableResult
    func userInteractive<R>(after seconds: TimeInterval? = nil,
                                 _ block: @escaping (Output) -> R) -> AsyncBlock<Output, R> {
        chain(queue: .userInteractive, after: seconds, block: block)
    }

    @discardableResult
    func userInitiated<R>(after seconds: TimeInterval? = nil,
                               _ block: @escaping (Output) -> R) -> AsyncBlock<Output, R> {
        chain(queue: .userInitiated, after: seconds, block: block)
    }
    
    @discardableResult
    func utility<R>(after seconds: TimeInterval? = nil,
                         _ block: @escaping (Output) -> R) -> AsyncBlock<Output, R> {
        chain(queue: .utility, after: seconds, block: block)
    }
    
    @discardableResult
    func background<R>(after seconds: TimeInterval? = nil,
                            _ block: @escaping (Output) -> R) -> AsyncBlock<Output, R> {
        chain(queue: .background, after: seconds, block: block)
    }
    
    @discardableResult
    func custom<R>(queue: DispatchQueue,
                        after seconds: TimeInterval? = nil,
                        _ block: @escaping (Output) -> R) -> AsyncBlock<Output, R> {
        chain(queue: .custom(queue: queue), after: seconds, block: block)
    }
        
    @discardableResult
    func wait(seconds: TimeInterval? = nil) -> DispatchTimeoutResult {
        let timeout = seconds.flatMap { DispatchTime.now() + $0 } ?? .distantFuture
        return block.wait(timeout: timeout)
    }
    
    func cancel() {
        block.cancel()
    }
    
    private func chain<R>(queue: GCD,
                               after seconds: TimeInterval? = nil,
                               block chain: @escaping (Output) -> R) -> AsyncBlock<Output, R> {
        let result = _Reference<R>()
        let executor = DispatchWorkItem(block: {
            result.value = chain(self.value!)
        })

        let queue = queue.queue
        if let seconds {
            block.notify(queue: queue) {
                let time = DispatchTime.now() + seconds
                queue.asyncAfter(deadline: time, execute: executor)
            }
        } else {
            block.notify(queue: queue, execute: executor)
        }

        return AsyncBlock<Output, R>(input: output, output: result, executor)
    }
}

// MARK: -  Apply

public enum Apply {
    public static func userInteractive(_ iterations: Int,
                                       block: @escaping (Int) -> ()) {
        GCD.userInteractive.queue.async {
            DispatchQueue.concurrentPerform(iterations: iterations, execute: block)
        }
    }
    
    public static func userInitiated(_ iterations: Int,
                                     block: @escaping (Int) -> ()) {
        GCD.userInitiated.queue.async {
            DispatchQueue.concurrentPerform(iterations: iterations, execute: block)
        }
    }
    
    public static func utility(_ iterations: Int,
                               block: @escaping (Int) -> ()) {
        GCD.utility.queue.async {
            DispatchQueue.concurrentPerform(iterations: iterations, execute: block)
        }
    }
    
    public static func background(_ iterations: Int,
                                  block: @escaping (Int) -> ()) {
        GCD.background.queue.async {
            DispatchQueue.concurrentPerform(iterations: iterations, execute: block)
        }
    }
    
    public static func custom(queue: DispatchQueue, iterations: Int, block: @escaping (Int) -> ()) {
        queue.async {
            DispatchQueue.concurrentPerform(iterations: iterations, execute: block)
        }
    }
}

// MARK: -  Group

public struct AsyncGroup {
    private let group = DispatchGroup()

    public init() {}
    
    private func async(queue: GCD,
                       block: @escaping () -> Void) {
        queue.queue.async(group: group, execute: block)
    }
    
    public func enter() {
        group.enter()
    }

    public func leave() {
        group.leave()
    }
    
    public func main(_ block: @escaping () -> Void) {
        async(queue: .main, block: block)
    }
    
    public func userInteractive(_ block: @escaping () -> Void) {
        async(queue: .userInteractive, block: block)
    }
    
    public func userInitiated(_ block: @escaping () -> Void) {
        async(queue: .userInitiated, block: block)
    }
    
    public func utility(_ block: @escaping () -> Void) {
        async(queue: .utility, block: block)
    }
    
    public func background(_ block: @escaping () -> Void) {
        async(queue: .background, block: block)
    }
    
    public func custom(queue: DispatchQueue, block: @escaping () -> Void) {
        async(queue: .custom(queue: queue), block: block)
    }
    
    @discardableResult
    public func wait(seconds: TimeInterval? = nil) -> DispatchTimeoutResult {
        let timeout = seconds.flatMap { DispatchTime.now() + $0 } ?? .distantFuture
        return group.wait(timeout: timeout)
    }
}

// MARK: -  Description

private enum QoSClassDescription: String {
    case main = "Main"
    case userInteractive = "User Interactive"
    case userInitiated = "User Initiated"
    case `default` = "Default"
    case utility = "Utility"
    case background = "Background"
    case unspecified = "Unspecified"
    case unknown = "Unknown"
}

extension qos_class_t: CustomStringConvertible {
     public var description: String {
        let result: QoSClassDescription
        switch self {
            case qos_class_main(): result = .main
            case DispatchQoS.QoSClass.userInteractive.rawValue: result = .userInteractive
            case DispatchQoS.QoSClass.userInitiated.rawValue: result = .userInitiated
            case DispatchQoS.QoSClass.default.rawValue: result = .default
            case DispatchQoS.QoSClass.utility.rawValue: result = .utility
            case DispatchQoS.QoSClass.background.rawValue: result = .background
            case DispatchQoS.QoSClass.unspecified.rawValue: result = .unspecified
            default: result = .unknown
        }
        return result.rawValue
    }
}

extension DispatchQoS.QoSClass: CustomStringConvertible {
    private var main: DispatchQoS.QoSClass {
        DispatchQoS.QoSClass(rawValue: qos_class_main())!
    }

    public var description: String {
        let result: QoSClassDescription
        switch self {
            case main: result = .main
            case .userInteractive: result = .userInteractive
            case .userInitiated: result = .userInitiated
            case .default: result = .default
            case .utility: result = .utility
            case .background: result = .background
            case .unspecified: result = .unspecified
            @unknown default: result = .unknown
        }
        return result.rawValue
    }
}

