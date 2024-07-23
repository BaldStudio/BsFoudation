//
//  DictionaryTests.swift
//  BsFoundationTests
//
//  Created by Runze Chang on 2024/7/24.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

class DictionaryTests: XCTestCase {
    func testSafeAccessInt() {
        let dict: [String: Any] = [
            "int": 1,
            "int1": Int16(11),
            "bool": true,
            "string": "string",
            "string1": "10",
            "string2": "10sss",
            "array": [1, 2, 3],
            "dictionary": ["a": 1, "b": 2],
            "uint": UInt(11),
            "float": Float(1.1),
            "NSNumber": NSNumber(value: 22),
            "url": URL(string: "www.baidu.com")!,
            "data": Data(),
            "date": Date()
        ]
        
        let v1: Int = dict.safe(intForKey: "int")
        XCTAssertTrue(v1 == 1)
        
        let v1_1: Int = dict.safe(intForKey: "int1")
        XCTAssertFalse(v1_1 == 11)  // 不兼容 Int16

        let v2: Int = dict.safe(intForKey: "bool")
        XCTAssertTrue(v2 == 1)
        
        let v3: Int = dict.safe(intForKey: "string")
        XCTAssertTrue(v3 == 0)  // 都是字母，转不了 int
        
        let v3_1: Int = dict.safe(intForKey: "string1")
        XCTAssertTrue(v3_1 == 10) // "10" 转 int 为 10

        let v3_2: Int = dict.safe(intForKey: "string2")
        XCTAssertTrue(v3_2 == 0) // "10sss" 转 int 为 0

        let v4: Int = dict.safe(intForKey: "array")
        XCTAssertTrue(v4 == 0)
        
        let v5: Int = dict.safe(intForKey: "dictionary")
        XCTAssertTrue(v5 == 0)
        
        let v6: Int = dict.safe(intForKey: "uint")
        XCTAssertFalse(v6 == 11)  // 不兼容 UInt

        let v7: Int = dict.safe(intForKey: "float")
        XCTAssertTrue(v7 == 0)

        let v8: Int = dict.safe(intForKey: "NSNumber")
        XCTAssertTrue(v8 == 22)  // NSNumber类型的值默认是直接转换成Int类型
        
        let v9: Int = dict.safe(intForKey: "url")
        XCTAssertTrue(v9 == 0)

        let v10: Int = dict.safe(intForKey: "data")
        XCTAssertTrue(v10 == 0)

        let v11: Int = dict.safe(intForKey: "date")
        XCTAssertTrue(v11 == 0)
    }
    
    func testSafeAccessBool() {
        let dict: [String: Any] = [
            "int": 1,
            "bool": true,
            "string": "string",
            "string1": "TrUe",
            "array": [1, 2, 3],
            "dictionary": ["a": 1, "b": 2]
        ]

        let v1: Bool = dict.safe(boolForKey: "int")
        XCTAssertTrue(v1 == true)

        let v2: Bool = dict.safe(boolForKey: "bool")
        XCTAssertTrue(v2 == true)
        
        let v3: Bool = dict.safe(boolForKey: "string")
        XCTAssertTrue(v3 == false)
        
        let v3_1: Bool = dict.safe(boolForKey: "string1")
        XCTAssertTrue(v3_1 == true)

        let v4: Bool = dict.safe(boolForKey: "array")
        XCTAssertTrue(v4 == false)

        let v5: Bool = dict.safe(boolForKey: "dictionary")
        XCTAssertTrue(v5 == false)
    }
    
    func testSafeAccessString() {
        let dict: [String: Any] = [
            "int": 1,
            "bool": true,
            "string": "string",
            "array": [1, 2, 3],
            "dictionary": ["a": 1, "b": 2]
        ]

        let v1: String = dict.safe(stringForKey: "int")
        XCTAssertTrue(v1 == "1")

        let v2: String = dict.safe(stringForKey: "bool")
        XCTAssertTrue(v2 == "true")
        
        let v3: String = dict.safe(stringForKey: "string")
        XCTAssertTrue(v3 == "string")
        
        let v4: String = dict.safe(stringForKey: "array")
        XCTAssertTrue(v4 == .empty)
        
        let v5: String = dict.safe(stringForKey: "dictionary")
        XCTAssertTrue(v5 == .empty)
    }
    
    func testSafeAccessArray() {
        let dict: [String: Any] = [
            "int": 1,
            "bool": true,
            "string": "string",
            "array": [1, 2, 3],
            "array1": [1, "2", "3"],
            "dictionary": ["a": 1, "b": 2]
        ]
        
        let v1: [Any] = dict.safe(arrayForKey: "int")
        XCTAssertTrue(v1.isEmpty)
        
        let v2: [Any] = dict.safe(arrayForKey: "bool")
        XCTAssertTrue(v2.isEmpty)

        let v3: [Any] = dict.safe(arrayForKey: "string")
        XCTAssertTrue(v3.isEmpty)

        let v4: [Int] = dict.safe(arrayForKey: "array")
        XCTAssertTrue(v4 == [1, 2, 3])
        
        let v4_1: [Any] = dict.safe(arrayForKey: "array")
        XCTAssertTrue(v4_1.count == 3)
        XCTAssertTrue(v4_1.contains(where: { $0 as? Int == 1 }))
        XCTAssertTrue(v4_1.contains(where: { $0 as? Int == 2 }))
        XCTAssertTrue(v4_1.contains(where: { $0 as? Int == 3 }))

        let v4_2: [Int] = dict.safe(arrayForKey: "array1")
        XCTAssertTrue(v4_2.isEmpty)
        
        let v4_3: [Any] = dict.safe(arrayForKey: "array1")
        XCTAssertTrue(v4_3.isNotEmpty)

        let v5: [Any] = dict.safe(arrayForKey: "dictionary")
        XCTAssertTrue(v5.isEmpty)
    }
    
    func testSafeAccessDictionary() {
        let dict: [String: Any] = [
            "int": 1,
            "bool": true,
            "string": "string",
            "array": [1, 2, 3],
            "dictionary": ["a": 1, "b": 2],
            "dictionary1": ["a": 1, "b": "2"]
        ]

        let v1: [String: Any] = dict.safe(dictionaryForKey: "bool")
        XCTAssertTrue(v1.isEmpty)
        
        let v2: [String: Any] = dict.safe(dictionaryForKey: "string")
        XCTAssertTrue(v2.isEmpty)

        let v3: [String: Any] = dict.safe(dictionaryForKey: "array")
        XCTAssertTrue(v3.isEmpty)

        let v4: [String: Any] = dict.safe(dictionaryForKey: "dictionary")
        XCTAssertTrue((v4["a"] as? Int) == 1 && (v4["b"] as? Int) == 2)
        
        let v4_1: [String: Int] = dict.safe(dictionaryForKey: "dictionary")
        XCTAssertTrue(v4_1.isNotEmpty)
        
        let v4_2: [String: Any] = dict.safe(dictionaryForKey: "dictionary1")
        XCTAssertTrue((v4_2["a"] as? Int) == 1 && (v4_2["b"] as? String) == "2")

        let v4_3: [String: Int] = dict.safe(dictionaryForKey: "dictionary1")
        XCTAssertTrue(v4_3.isEmpty)

    }
    
    func testSafeAccessValue() {
        let dict: [String: Any] = [
            "int": 1,
            "string": "string",
            "array": [1, 2, 3],
            "dictionary": ["a": 1, "b": 2],
        ]
        
        let v1: Int? = dict.safe(valueForKey: "int")
        XCTAssertTrue(v1.isNotNil)
        XCTAssertTrue(v1 == 1)

        let v1_1: UInt? = dict.safe(valueForKey: "int")
        XCTAssertTrue(v1_1.isNil)

        let v2: String? = dict.safe(valueForKey: "string")
        XCTAssertTrue(v2 == "string")
        
        let v3: [Int] = dict.safe(valueForKey: "array") ?? .empty
        XCTAssertTrue(v3.isNotEmpty)
        
        let v4: [String: Int] = dict.safe(valueForKey: "dictionary") ?? .empty
        XCTAssertTrue(v4.isNotEmpty)
        
        let v5: Any? = dict.safe(valueForKey: "not-exist")
        XCTAssertTrue(v5.isNil) // 这里有神奇的Optional嵌套问题，可以研究下
    }
    
    func testContains() {
        let dict = ["a": 1, "b": 2]
        XCTAssertTrue(dict.contains(key: "a"))
        XCTAssertTrue(dict.contains(value: 1))
        XCTAssertFalse(dict.contains(key: "c"))
        XCTAssertFalse(dict.contains(value: 3))
    }
    
    func testOperators() {
        var dict = ["a": 1, "b": 2]
        let otherDict = ["c": 3, "d": 4]
        dict += otherDict
        XCTAssertTrue(dict == ["a": 1, "b": 2, "c": 3, "d": 4])
    }
}
