//
//  Geometry.swift
//  BsSwiftPlus
//
//  Created by crzorz on 2021/7/16.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import UIKit

// MARK: - CGRect

extension CGRect: ExpressibleByArrayLiteral {
    
    @inlinable
    public init(arrayLiteral elements: CGFloat...) {
        assert(elements.count == 4)
        self.init(x: elements[0], y: elements[1], width: elements[2], height: elements[3])
    }
    
}


// MARK: - Point

public extension CGPoint {
    
    @inlinable
    static func + (left: CGPoint, right: CGPoint) -> CGPoint {
        CGPoint(x: left.x + right.x, y: left.y + right.y)
    }

    @inlinable
    static func += (left: inout CGPoint, right: CGPoint) {
        left = left + right
    }
    
    @inlinable
    static func - (left: CGPoint, right: CGPoint) -> CGPoint {
        CGPoint(x: left.x - right.x, y: left.y - right.y)
    }

    @inlinable
    static func -= (left: inout CGPoint, right: CGPoint) {
        left = left - right
    }
    
    @inlinable
    static func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
        CGPoint(x: point.x * scalar, y: point.y * scalar)
    }

    @inlinable
    static func *= (point: inout CGPoint, scalar: CGFloat) {
        point = point * scalar
    }
     
    @inlinable
    static func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
        CGPoint(x: point.x / scalar, y: point.y / scalar)
    }

    @inlinable
    static func /= (point: inout CGPoint, scalar: CGFloat) {
        point = point / scalar
    }

}

extension CGPoint: ExpressibleByArrayLiteral {
    
    @inlinable
    public init(arrayLiteral elements: CGFloat...) {
        assert(elements.count == 2)
        self.init(x: elements[0], y: elements[1])
    }
    
}

// MARK: - Size

public extension CGSize {

    @inlinable
    static func + (left: CGSize, right: CGSize) -> CGSize {
        CGSize(width: left.width + right.width, height: left.height + right.height)
    }

    @inlinable
    static func += (left: inout CGSize, right: CGSize) {
        left = left + right
    }
    
    @inlinable
    static func - (left: CGSize, right: CGSize) -> CGSize {
        CGSize(width: left.width - right.width, height: left.height - right.height)
    }

    @inlinable
    static func -= (left: inout CGSize, right: CGSize) {
        left = left - right
    }
    
    @inlinable
    static func * (size: CGSize, scalar: CGFloat) -> CGSize {
        CGSize(width: size.width * scalar, height: size.height * scalar)
    }

    @inlinable
    static func *= (size: inout CGSize, scalar: CGFloat) {
        size = size * scalar
    }
     
    @inlinable
    static func / (size: CGSize, scalar: CGFloat) -> CGSize {
        CGSize(width: size.width / scalar, height: size.height / scalar)
    }

    @inlinable
    static func /= (size: inout CGSize, scalar: CGFloat) {
        size = size / scalar
    }
    
}

extension CGSize: ExpressibleByArrayLiteral {
    @inlinable
    public init(arrayLiteral elements: CGFloat...) {
        assert(elements.count == 2)
        self.init(width: elements[0], height: elements[1])
    }
}

// MARK: - UIEdgeInsets

public extension UIEdgeInsets {

    @inlinable
    init(horizontal: CGFloat = 0, vertical: CGFloat = 0) {
        self.init(top: vertical,
                  left: horizontal,
                  bottom: vertical,
                  right: horizontal)
    }
    
    @inlinable
    init(all inset: CGFloat) {
        self.init(top: inset,
                  left: inset,
                  bottom: inset,
                  right: inset)
    }
    
    @inlinable
    static func only(top: CGFloat = 0,
                     left: CGFloat = 0,
                     bottom: CGFloat = 0,
                     right: CGFloat = 0) -> Self {
        Self(top: top, left: left, bottom: bottom, right: right)
    }
    
}

extension UIEdgeInsets: ExpressibleByArrayLiteral {
    
    @inlinable
    public init(arrayLiteral elements: CGFloat...) {
        assert(elements.count == 4)
        self.init(top: elements[0],
                  left: elements[1],
                  bottom: elements[2],
                  right: elements[3])
    }
    
}
