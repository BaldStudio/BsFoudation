//
//  OptionalTests.swift
//  BsFoundationTests
//
//  Created by changrunze on 2023/8/3.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

@testable import BsFoundation

class OptionalTests: XCTestCase {
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
        XCTAssertTrue(foo8.isNotNil)
    }
        
    func testNested() {
//        let a: Int? = nil
//        let b: Int?? = a
//        let c: Int??? = b
//        let d: Int??? = nil
//        XCTAssertTrue(a == nil)
//        XCTAssertFalse(b == nil)
//        XCTAssertFalse(c == nil)
//        XCTAssertTrue(d == nil)
//        
//        XCTAssertTrue(a.isNil)
//        XCTAssertTrue(b.isNil)
//        XCTAssertTrue(c.isNil)
//        XCTAssertTrue(d.isNil)
    }
}

//extension Optional {
//    var isNil: Bool {
//        switch self {
//        case let .some(wrapped):
//            if case let .some(inner) = wrapped as Optional<Any> {
//                let inner = inner as Optional<Any>
//                if case .none = inner {
//                    return true
//                }
//                return inner.isNil
//            }
//            return false
//        case .none:
//            return true
//        }
//    }
//}

