//
//  DispatchQueue.swift
//  BsSwiftX
//
//  Created by crzorz on 2021/7/16.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import Foundation

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
