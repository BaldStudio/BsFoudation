//
//  Date+.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/16.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

public enum Timestamp {
    public static var seconds: Int {
        Date().timeIntervalSince1970.asInt
    }
    
    public static var milliseconds: Int64 {
        Int64(Date().timeIntervalSince1970 * 1000)
    }
}

public extension Date {

}
