//
//  StringTests.swift
//  BsFoundationTests
//
//  Created by crzorz on 2022/10/19.
//  Copyright © 2022 BaldStudio. All rights reserved.
//

@testable import BsFoundation

class StringTests: XCTestCase {
    
    func testSlice() {
        let str = "12345"
        // 正常用
        var result = str[2...]
        XCTAssertTrue(result == "345")
        
        // 不太正常
        result = str[0...]
        XCTAssertTrue(result == "12345")

        result = str[0...0]
        XCTAssertTrue(result == "1")

        // 正常用
        result = str[0..<1]
        XCTAssertTrue(result == "1")
        result = str[..<1]
        XCTAssertTrue(result == "1")

        result = str[...1]
        XCTAssertTrue(result == "12")
        result = str[0...1]
        XCTAssertTrue(result == "12")
        
        result = str[3...]
        XCTAssertTrue(result == "45")
        
        result = str[0...99]
        XCTAssertTrue(result == "12345")

        result = str[...99]
        XCTAssertTrue(result == "12345")

        result = str[99...]
        XCTAssertTrue(result == "5")
        
        result = str[99...99]
        XCTAssertTrue(result == "5")
    }
    
    func testOperators() {
        let target = "111111"
        let value = "1" * 6
        XCTAssertTrue(value == target)
    }
}
