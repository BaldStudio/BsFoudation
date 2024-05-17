//
//  JSONKey.swift
//  BsFoundation
//
//  Created by changrunze on 2024/2/4.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

struct JSONKey: CodingKey {
    var stringValue: String
    var intValue: Int?

    init?(stringValue: String) {
        self.stringValue = stringValue
        intValue = nil
    }

    init?(intValue: Int) {
        stringValue = "\(intValue)"
        self.intValue = intValue
    }

    init(index: Int) {
        stringValue = "Index \(index)"
        intValue = index
    }

    static let `super` = JSONKey(stringValue: "super")!
}

