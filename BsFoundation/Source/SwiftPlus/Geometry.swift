//
//  Geometry.swift
//  BsSwiftPlus
//
//  Created by crzorz on 2021/7/16.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import UIKit

//MARK: - Point

public extension CGPoint {
    static func + (left: CGPoint, right: CGPoint) -> CGPoint {
        CGPoint(x: left.x + right.x, y: left.y + right.y)
    }

    static func += (left: inout CGPoint, right: CGPoint) {
        left = left + right
    }
    
    
    static func - (left: CGPoint, right: CGPoint) -> CGPoint {
        CGPoint(x: left.x - right.x, y: left.y - right.y)
    }

    static func -= (left: inout CGPoint, right: CGPoint) {
        left = left - right
    }
    
    
    static func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
        CGPoint(x: point.x * scalar, y: point.y * scalar)
    }

    static func *= (point: inout CGPoint, scalar: CGFloat) {
        point = point * scalar
    }
     
    
    static func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
        CGPoint(x: point.x / scalar, y: point.y / scalar)
    }

    static func /= (point: inout CGPoint, scalar: CGFloat) {
        point = point / scalar
    }

}

//MARK: - Size

public extension CGSize {
    static func + (left: CGSize, right: CGSize) -> CGSize {
        CGSize(width: left.width + right.width, height: left.height + right.height)
    }

    static func += (left: inout CGSize, right: CGSize) {
        left = left + right
    }
    
    
    static func - (left: CGSize, right: CGSize) -> CGSize {
        CGSize(width: left.width - right.width, height: left.height - right.height)
    }

    static func -= (left: inout CGSize, right: CGSize) {
        left = left - right
    }
    
    
    static func * (size: CGSize, scalar: CGFloat) -> CGSize {
        CGSize(width: size.width * scalar, height: size.height * scalar)
    }

    static func *= (size: inout CGSize, scalar: CGFloat) {
        size = size * scalar
    }
     
    
    static func / (size: CGSize, scalar: CGFloat) -> CGSize {
        CGSize(width: size.width / scalar, height: size.height / scalar)
    }

    static func /= (size: inout CGSize, scalar: CGFloat) {
        size = size / scalar
    }

}
