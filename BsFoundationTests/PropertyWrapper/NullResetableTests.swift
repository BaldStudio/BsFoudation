//
//  NullResetableTests.swift
//  BsFoundationTests
//
//  Created by crzorz on 2022/10/19.
//  Copyright © 2022 BaldStudio. All rights reserved.
//

@testable import BsFoundation

class NullResetableTests: XCTestCase {
    static func defaultText() -> String {
        "0"
    }
        
    @NullResetable
    var foo: String! = "0"
    
    @NullResetable
    var foo1: String? = "1"
    
    @NullResetable(resetter: defaultText())
    var foo2: String?
    
    @NullResetable(resetter: "3")
    var foo3: String?

    func testUsage() {
        XCTAssertTrue(foo == "0")
        foo = "1"
        XCTAssertTrue(foo == "1")
        foo = nil
        XCTAssertTrue(foo == "0")
        
        XCTAssertTrue(foo1 == "1")
        foo1 = "0"
        XCTAssertTrue(foo1 == "0")
        foo1 = nil
        XCTAssertTrue(foo1 == "1")
        
        XCTAssertTrue(foo2 == "0")
        foo2 = "1"
        XCTAssertTrue(foo2 == "1")
        foo2 = nil
        XCTAssertTrue(foo2 == "0")
        
        XCTAssertTrue(foo3 == "3")
        foo3 = "1"
        XCTAssertTrue(foo3 == "1")
        foo3 = nil
        XCTAssertTrue(foo3 == "3")
    }
    
    func testInherit() {
        let child = Child()
        XCTAssertTrue(child.foo == "0")
        child.foo = "1"
        XCTAssertTrue(child.foo == "1")
        child.foo = nil
        XCTAssertTrue(child.foo == "0")
        
        XCTAssertTrue(child.foo1 == "0")
        child.foo1 = "11"
        XCTAssertTrue(child.foo1 == "0")
        child.foo1 = nil
        XCTAssertTrue(child.foo1 == "0")
        
        XCTAssertTrue(child.foo2 == "2")
        child.foo2 = "11"
        XCTAssertTrue(child.foo2 == "1")
        child.foo2 = nil
        XCTAssertTrue(child.foo2 == "1")
    }
}

private class Parent {
    @NullResetable
    var foo: String! = "0"
    
    @NullResetable
    var foo1: String! = "1"

    @NullResetable
    var foo2: String! = "2"
}

private class Child: Parent {
    override var foo: String! {
        set {
            super.foo = newValue
        }
        get {
            super.foo
        }
    }
    
    override var foo1: String! {
        set {
            super.foo1 = newValue
        }
        get {
            return "0"
        }
    }
    
    override var foo2: String! {
        set {
            super.foo2 = "1"
        }
        get {
            super.foo2
        }
    }
}
