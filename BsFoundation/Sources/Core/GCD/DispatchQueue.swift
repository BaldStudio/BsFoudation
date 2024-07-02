//
//  DispatchQueue.swift
//  BsSwiftX
//
//  Created by crzorz on 2021/7/16.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import Foundation

// MARK: -  Main

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

// MARK: -  Delay

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

// MARK: -  Once

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

// MARK: -  debounce & throttle

public extension DispatchQueue {
    
    // MARK: - debounce

    // https://gist.github.com/simme/b78d10f0b29325743a18c905c5512788
    //
    func debounce(interval: TimeInterval = 1.0,
                  action: @escaping Block) -> Block {
        var worker: DispatchWorkItem?
        return {
            worker?.cancel()
            worker = DispatchWorkItem { action() }
            self.asyncAfter(deadline: .now() + interval, execute: worker!)
        }
    }
    
    // MARK: - throttle
    
    func throttle(interval: TimeInterval = 1.0,
                  action: @escaping Block) -> Block {
        var worker: DispatchWorkItem?
        
        var lastFire = DispatchTime.now()
        let deadline = { lastFire + interval }
                
        return {
            guard worker == nil else { return }
            
            worker = DispatchWorkItem {
                action()
                lastFire = DispatchTime.now()
                worker = nil
            }
            
            if DispatchTime.now() > deadline() {
                self.async(execute: worker!)
                return
            }

            self.asyncAfter(deadline: .now() + interval, execute: worker!)
        }
    }
}
