//
//  AnyOptionalTests.swift
//  BsFoundationTests
//
//  Created by changrunze on 2023/8/3.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

import Foundation

class AnyOptionalTests: XCTestCase {
    
    func testInvoke() {
        let foo1: Bool? = nil
        XCTAssertTrue(foo1.isNil)
        
        let foo2: Int? = nil
        XCTAssertTrue(foo2.isNil)
        
        let foo3: Float? = nil
        XCTAssertTrue(foo3.isNil)
        
        let foo4: String? = nil
        XCTAssertTrue(foo4.isNil)
        
        let foo5: AnyObject? = nil
        XCTAssertTrue(foo5.isNil)
        
        let foo6: Any? = nil
        XCTAssertTrue(foo6.isNil)
        
        let foo7: AnyClass? = nil
        XCTAssertTrue(foo7.isNil)
        
        var foo8: NSObject? = nil
        XCTAssertTrue(foo8.isNil)
        foo8 = NSObject()
        XCTAssertFalse(foo8.isNil)
    }
}
