//
//  GCDTimerTests.swift
//  BsFoundationTests
//
//  Created by crzorz on 2022/12/15.
//  Copyright © 2022 BaldStudio. All rights reserved.
//

import XCTest

final class GCDTimerTests: XCTestCase {
    var timer: GCDTimer!
    override func setUp() {
        timer = nil
    }
    
    override func tearDown() {
        timer.invalidate()
        timer = nil
    }
    
    func testSelector() {
        timer = GCDTimer.scheduled(timeInterval: 0.5, target: self, selector: #selector(onTimer(_:)))
        timer.fire()
        timer.tolerance = 0.01
    }

    func testBlock() {
        timer = GCDTimer.scheduled(timeInterval: 0.01, block: { timer in
            print("block timer: \(timer)")
        })
        timer.fire()
    }

    func testAsyncQueue() {
        timer = GCDTimer.scheduled(timeInterval: 0.01, queue: DispatchQueue(label: "tset"), block: { timer in
            print("async block timer: \(timer)")
        })
        timer.fire()
    }
}

extension GCDTimerTests {
    @objc func onTimer(_ sender: AnyObject) {
        print("on timer: \(sender)")
    }
}
