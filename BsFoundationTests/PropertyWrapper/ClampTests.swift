//
//  PropertyWrapper.swift
//  BsFoundationTests
//
//  Created by crzorz on 2022/10/19.
//  Copyright © 2022 BaldStudio. All rights reserved.
//

@testable import BsFoundation

class ClampTests: XCTestCase {

    @Clamp(0...1)
    var floatValue: CGFloat = 0

    @Clamp(0...10)
    var intValue: Int = 0

    func testFloatValue() {
        floatValue = -1
        XCTAssertTrue(floatValue == 0)
        
        floatValue = 0
        XCTAssertTrue(floatValue == 0)
        
        floatValue = 0.5
        XCTAssertTrue(floatValue == 0.5)

        floatValue = 1
        XCTAssertTrue(floatValue == 1)

        floatValue = 2
        XCTAssertTrue(floatValue == 1)
    }
    
    func testIntValue() {
        intValue = -1
        XCTAssertTrue(intValue == 0)
        
        intValue = 0
        XCTAssertTrue(intValue == 0)
        
        intValue = 1
        XCTAssertTrue(intValue == 1)

        intValue = 5
        XCTAssertTrue(intValue == 5)

        intValue = 10
        XCTAssertTrue(intValue == 10)

        intValue = 11
        XCTAssertTrue(intValue == 10)

    }
}
