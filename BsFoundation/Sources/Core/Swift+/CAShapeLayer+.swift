//
//  CAShapeLayer+.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/16.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

public extension CAShapeLayer {
    func applying(rounded radius: CGFloat, corners: UIRectCorner = .allCorners, rect: CGRect) {
        let bezierPath = UIBezierPath(roundedRect: rect,
                                      byRoundingCorners: corners,
                                      cornerRadii: [radius, radius])
        path = bezierPath.cgPath
        frame = rect
    }
}
