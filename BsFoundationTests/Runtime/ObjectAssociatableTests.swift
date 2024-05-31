//
//  ObjectAssociatableTests.swift
//  BsFoundationTests
//
//  Created by changrunze on 2023/8/3.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

@testable import BsFoundation

class ObjectAssociatableTests: XCTestCase {
    
    func testInstanceFunc() {
        let test1 = TestClass()
        test1.set(associate: 1, for: &key, atomic: false)
        XCTAssertTrue(test1.value<Int>(forAssociated: &key) == 1)
        
        test1.set(associateCopy: 1, for: &key, atomic: false)
        XCTAssertTrue(test1.value<Int>(forAssociated: &key) == 1)
        
        test1.set(associate: "1", for: &key, atomic: false)
        XCTAssertTrue(test1.value<String>(forAssociated: &key) == "1")
        
        test1.set(associateCopy: "1", for: &key, atomic: false)
        XCTAssertTrue(test1.value<String>(forAssociated: &key) == "1")
        
        let foo1 = NSObject()
        test1.set(associateWeak: foo1, for: &key, atomic: false)
        XCTAssertTrue(test1.value<NSObject>(forAssociated: &key) == foo1)
        
        let foo2 = TestClass()
        test1.set(associateWeak: foo2, for: &key, atomic: false)
        XCTAssertNotNil(test1.value<TestClass>(forAssociated: &key))
    }
    
    func testStaticFunc() {
        let test2 = TestClass.self
        test2.set(associate: 1, for: &key, atomic: false)
        XCTAssertTrue(test2.value<Int>(forAssociated: &key) == 1)
        
        test2.set(associateCopy: 1, for: &key, atomic: false)
        XCTAssertTrue(test2.value<Int>(forAssociated: &key) == 1)
        
        test2.set(associate: "1", for: &key, atomic: false)
        XCTAssertTrue(test2.value<String>(forAssociated: &key) == "1")
        
        test2.set(associateCopy: "1", for: &key, atomic: false)
        XCTAssertTrue(test2.value<String>(forAssociated: &key) == "1")
        
        let foo3 = NSObject()
        test2.set(associateWeak: foo3, for: &key, atomic: false)
        XCTAssertTrue(test2.value<NSObject>(forAssociated: &key) == foo3)
        
        let foo4 = TestClass()
        test2.set(associateWeak: foo4, for: &key, atomic: false)
        XCTAssertNotNil(test2.value<TestClass>(forAssociated: &key))
    }
}

private var key = 0
class TestClass: ObjectAssociatable {}


