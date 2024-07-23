//
//  MainTaskTests.swift
//  si_foundationTests
//
//  Created by Runze Chang on 2024/7/23.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

class MainTaskTests: XCTestCase {
    func testMainAsyncOnMainThread() {
        var flag = 0
        MainTask {
            // 默认async
            XCTAssertTrue(Thread.isMainThread)
            // 由于创建MainTask的线程为主线程，MainTask内部会同步执行block，所以这里flag还没被修改
            XCTAssertTrue(flag == 0)
        }
        flag = 1
    }
    
    func testMainSyncOnMainThread() {
        var flag = 0
        MainTask(sync: true) {
            // 由于创建MainTask的线程为主线程，MainTask内部会同步执行block，所以这里flag还没被修改
            XCTAssertTrue(Thread.isMainThread)
            XCTAssertTrue(flag == 0)
        }
        flag = 1
    }
    
    func testMainAsyncOnBackgroundThread() {
        var flag = 0
        let exp = expectation(description: "testMainAsyncOnBackgroundThread")
        DispatchQueue.global().async {
            MainTask {
                XCTAssertTrue(Thread.isMainThread)
                // 异步队列切回主线程，MainTask默认异步执行block，所以这里flag已经被修改
                XCTAssertTrue(flag == 1)
                exp.fulfill()
            }
            flag = 1
        }
        wait(for: [exp], timeout: 1)
    }
    
    func testMainSyncOnBackgroundThread() {
        var flag = 0
        let exp = expectation(description: "testMainSyncOnBackgroundThread")
        DispatchQueue.global().async {
            MainTask(sync: true) {
                XCTAssertTrue(Thread.isMainThread)
                // 异步队列切回主线程，MainTask同步执行block，所以这里flag还未被修改
                XCTAssertTrue(flag == 0)
                exp.fulfill()
            }
            flag = 1
        }
        wait(for: [exp], timeout: 1)
    }
    
    func testMainSyncOnSyncBackgroundThread() {
        var flag = 0
        let exp = expectation(description: "testMainSyncOnSyncBackgroundThread")
        DispatchQueue.global().sync {
            MainTask(sync: true) {
                XCTAssertTrue(Thread.isMainThread)
                // 异步队列切回主线程，MainTask同步执行block，所以这里flag还未被修改
                XCTAssertTrue(flag == 0)
                exp.fulfill()
            }
            flag = 1
        }
        wait(for: [exp], timeout: 1)
    }
    
    func testNestInvokeWithAsyncAndSync() {
        var flag = 0
        let exp = expectation(description: "testNestInvokeWithAsyncAndSync")
        MainTask {
            MainTask(sync: true) {
                XCTAssertTrue(Thread.isMainThread)
                XCTAssertTrue(flag == 0)
                exp.fulfill()
            }
            flag = 1
        }
        wait(for: [exp], timeout: 1)
    }
    
    func testNestInvokeWithSyncAndSync() {
        var flag = 0
        let exp = expectation(description: "testNestInvokeWithSyncAndSync")
        MainTask(sync: true) {
            MainTask(sync: true) {
                XCTAssertTrue(Thread.isMainThread)
                XCTAssertTrue(flag == 0)
                exp.fulfill()
            }
            flag = 1
        }
        wait(for: [exp], timeout: 1)
    }
    
    func testNestInvokeWithSyncAndAsync() {
        var flag = 0
        let exp = expectation(description: "testNestInvokeWithSyncAndAsync")
        MainTask(sync: true) {
            MainTask {
                XCTAssertTrue(Thread.isMainThread)
                XCTAssertTrue(flag == 0)
                exp.fulfill()
            }
            flag = 1
        }
        wait(for: [exp], timeout: 1)
    }
}
