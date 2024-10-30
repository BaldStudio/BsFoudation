//
//  Geometry.swift
//  BsSwiftX
//
//  Created by crzorz on 2021/7/16.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

// MARK: - CGRect

extension CGRect: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: CGFloat...) {
        assert(elements.count == 4)
        self.init(x: elements[0], y: elements[1], width: elements[2], height: elements[3])
    }
}

// MARK: - Point

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

extension CGPoint: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: CGFloat...) {
        assert(elements.count == 2)
        self.init(x: elements[0], y: elements[1])
    }
}

// MARK: - Size

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

extension CGSize: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: CGFloat...) {
        assert(elements.count == 2)
        self.init(width: elements[0], height: elements[1])
    }
}

// MARK: - UIEdgeInsets

public extension UIEdgeInsets {
    init(horizontal: CGFloat = 0, vertical: CGFloat = 0) {
        self.init(top: vertical,
                  left: horizontal,
                  bottom: vertical,
                  right: horizontal)
    }
    
    static func all(_ inset: CGFloat) -> Self {
        UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }

    static func only(top: CGFloat = 0,
                     left: CGFloat = 0,
                     bottom: CGFloat = 0,
                     right: CGFloat = 0) -> Self {
        UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
    var vertical: CGFloat {
        `left` + `right`
    }
    
    var horizontal: CGFloat {
        top + bottom
    }
}

extension UIEdgeInsets: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: CGFloat...) {
        assert(elements.count == 4)
        self.init(top: elements[0],
                  left: elements[1],
                  bottom: elements[2],
                  right: elements[3])
    }
}
