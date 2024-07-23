//
//  DataTests.swift
//  BsFoundationTests
//
//  Created by crzorz on 2023/3/14.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

@testable import BsFoundation

final class DataTests: XCTestCase {
    func testAppendPositiveInt() {
        var data = Data()
        let v8: Int8 = 10
        data.append(v8.bigEndian)
        print("Positive Int8 \(data.bytes)")
        XCTAssertTrue(data.count == 1)

        data = Data()
        let v16: Int16 = 10
        data.append(v16.bigEndian)
        print("Positive Int16 \(data.bytes)")
        XCTAssertTrue(data.count == 2)

        data = Data()
        let v32: Int32 = 10
        data.append(v32.bigEndian)
        print("Positive Int32 \(data.bytes)")
        // 4字节，不够补0
        XCTAssertTrue(data.count == 4)

        data = Data()
        let v64: Int64 = 10
        data.append(v64.bigEndian)
        print("Positive Int64 \(data.bytes)")
        // 8字节，不够补0
        XCTAssertTrue(data.count == 8)
        
    }
    
    func testAppendNegativeInt() {
        var data = Data()
        let v8: Int8 = -10
        data.append(v8.bigEndian)
        print("Negative Int8 \(data.bytes)")
        XCTAssertTrue(data.count == 1)
        
        data = Data()
        let v16: Int16 = -10
        data.append(v16.bigEndian)
        print("Negative Int16 \(data.bytes)")
        XCTAssertTrue(data.count == 2)

        data = Data()
        let v32: Int32 = -10
        data.append(v32.bigEndian)
        print("Negative Int32 \(data.bytes)")
        // 4字节，不够补f
        XCTAssertTrue(data.count == 4)

        data = Data()
        let v64: Int64 = -10
        data.append(v64.bigEndian)
        print("Negative Int64 \(data.bytes)")
        // 8字节，不够补f
        XCTAssertTrue(data.count == 8)
    }

    
    func testAppendUnsignedInt() {
        var data = Data()
        let v8: UInt8 = 10
        data.append(v8.bigEndian)
        print("UInt8 \(data.bytes)")
        XCTAssertTrue(data.count == 1)
        
        data = Data()
        let v16: UInt16 = 10
        data.append(v16.bigEndian)
        print("UInt16 \(data.bytes)")
        XCTAssertTrue(data.count == 2)

        data = Data()
        let v32: UInt32 = 10
        data.append(v32.bigEndian)
        print("UInt32 \(data.bytes)")
        // 4字节，不够补0
        XCTAssertTrue(data.count == 4)

        data = Data()
        let v64: UInt64 = 10
        data.append(v64.bigEndian)
        print("UInt64 \(data.bytes)")
        // 8字节，不够补0
        XCTAssertTrue(data.count == 8)
    }
    
    func testAppendFloat() {
        var data: Data
        if #available(iOS 14.0, *) {
            data = Data()
            var v16: Float16 = 10
            data.append(v16)
            print("Positive Float16 \(data.bytes)")
            XCTAssertTrue(data.count == 2)
            
            data = Data()
            v16 = -10
            data.append(v16)
            print("Negative Float16 \(data.bytes)")
            XCTAssertTrue(data.count == 2)

        }
        
        data = Data()
        var v32: Float32 = 10
        data.append(v32)
        print("Positive Float32 \(data.bytes)")
        XCTAssertTrue(data.count == 4)

        data = Data()
        v32 = -10
        data.append(v32)
        print("Negative Float32 \(data.bytes)")
        XCTAssertTrue(data.count == 4)

        data = Data()
        var v64: Float64 = 10
        data.append(v64)
        print("Positive UInt64 \(data.bytes)")
        // 8字节，不够补0
        XCTAssertTrue(data.count == 8)
        
        data = Data()
        v64 = -10
        data.append(v64)
        print("Negative UInt64 \(data.bytes)")
        // 8字节，不够补0
        XCTAssertTrue(data.count == 8)
    }
}
