//
//  AsyncTaskTests.swift
//  si_foundationTests
//
//  Created by Runze Chang on 2024/7/23.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

class AsyncTaskTests: XCTest {
    func testAsync() {
        var flag = 0
        AsyncTask {
            XCTAssertFalse(Thread.isMainThread)
            XCTAssertTrue(flag == 1)
        }
        flag = 1

        DispatchQueue.global().async {
            var flag = 0
            AsyncTask {
                XCTAssertFalse(Thread.isMainThread)
                XCTAssertTrue(flag == 0)
            }
            flag = 1
        }
        
        var foo = 0
        let queue = DispatchQueue(label: "TestAsyncTask", attributes: .concurrent)
        AsyncTask(queue: queue) {
            XCTAssertFalse(Thread.isMainThread)
            XCTAssertTrue(foo == 1)
        }
        foo = 1
    }
}
