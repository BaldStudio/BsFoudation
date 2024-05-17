//
//  CAShapeLayer+.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/16.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

public extension CAShapeLayer {
    func applying(rounded rect: CGRect, radius: CGFloat, corners: UIRectCorner) {
        let bezierPath = UIBezierPath(roundedRect: rect,
                                      byRoundingCorners: corners,
                                      cornerRadii: [radius, radius])
        path = bezierPath.cgPath
        frame = rect
    }
}
