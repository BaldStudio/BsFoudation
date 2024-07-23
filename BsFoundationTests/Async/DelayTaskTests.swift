//
//  DelayTaskTests.swift
//  si_foundationTests
//
//  Created by Runze Chang on 2024/7/23.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

class DelayTaskTests: XCTestCase {
    func testDelayOnMain() {
        let exp = expectation(description: "testDelayOnMain")
        var flag = 0
        DelayTask(0.5) {
            XCTAssertTrue(Thread.isMainThread)
            flag = 1
            exp.fulfill()
        }
        XCTAssertTrue(flag == 0)
        wait(for: [exp], timeout: 0.5)
        XCTAssertTrue(flag == 1)
    }
    
    func testDelayOnBackgroundThread() {
        let exp = expectation(description: "testDelayOnBackgroundThread")
        var flag = 0
        DelayTask(0.5, queue: .global()) {
            XCTAssertFalse(Thread.isMainThread)
            flag = 1
            exp.fulfill()
        }
        XCTAssertTrue(flag == 0)
        wait(for: [exp], timeout: 0.5)
        XCTAssertTrue(flag == 1)
    }
    
    func testNestedInvoke() {
        let exp = expectation(description: "global")
        let exp1 = expectation(description: "main")
        var flag = 0
        DelayTask(0.5, queue: .global()) {
            XCTAssertFalse(Thread.isMainThread)
            flag = 1
            exp.fulfill()
            DelayTask(0.5) {
                XCTAssertTrue(Thread.isMainThread)
                flag = 2
                exp1.fulfill()
            }
        }
        XCTAssertTrue(flag == 0)
        wait(for: [exp], timeout: 0.5)
        XCTAssertTrue(flag == 1)
        
        wait(for: [exp1], timeout: 0.5)
        XCTAssertTrue(flag == 2)
    }
}
