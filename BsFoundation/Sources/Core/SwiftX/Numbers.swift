//
//  Numbers.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/17.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

// MARK: -  Bool

public extension Bool {
    var asInt: Int {
        self ? 1 : 0
    }

    var asCFBoolean: CFBoolean {
        self ? kCFBooleanTrue : kCFBooleanFalse
    }
}

// MARK: -  UnsignedInteger

public extension UnsignedInteger {
    var asInt: Int {
        Int(self)
    }
}

// MARK: -  Int

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

// MARK: -  BinaryFloatingPoint

public extension BinaryFloatingPoint {
    var asInt: Int {
        Int(self)
    }
}

// MARK: -  Double

public extension Double {
    var asNSNumber: NSNumber {
        NSNumber(floatLiteral: self)
    }
}
