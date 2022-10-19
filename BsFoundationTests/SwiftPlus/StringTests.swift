//
//  StringTests.swift
//  BsFoundationTests
//
//  Created by crzorz on 2022/10/19.
//  Copyright © 2022 BaldStudio. All rights reserved.
//

import XCTest

class StringTests: XCTestCase {
    
    func testSlice() {
        let str = "12345"
        // 正常用
        var result = str.bs.slice(at: 2)
        XCTAssertTrue(result == "345")
        
        // 不太正常
        result = str.bs.slice(at: -1)
        XCTAssertTrue(result == "12345")

        result = str.bs.slice(at: 99)
        XCTAssertTrue(result == "")

        // 正常用
        result = str.bs.slice(at: 0, count: 1)
        XCTAssertTrue(result == "1")
        
        result = str.bs.slice(at: 1, count: 2)
        XCTAssertTrue(result == "23")
        
        result = str.bs.slice(at: 3, count: 2)
        XCTAssertTrue(result == "45")
        
        // 不太正常
        result = str.bs.slice(at: 0, count: -1)
        XCTAssertTrue(result == "")

        result = str.bs.slice(at: -1, count: 2)
        XCTAssertTrue(result == "12")

        result = str.bs.slice(at: -1, count: 99)
        XCTAssertTrue(result == "12345")

        result = str.bs.slice(at: 99, count: 99)
        XCTAssertTrue(result == "")

    }
}
