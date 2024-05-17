//
//  Numbers.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/17.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

public extension Bool {
    var asInt: Int {
        self ? 1 : 0
    }
}

public extension UInt {
    var asInt: Int {
        Int(self)
    }
}

public extension Int {
    var asBool: Bool {
        self != 0
    }
    
    var asString: String {
        "\(self)"
    }
    
    var asDouble: Double {
        Double(self)
    }
    
}

public extension BinaryFloatingPoint {
    var asInt: Int {
        Int(self)
    }
}
