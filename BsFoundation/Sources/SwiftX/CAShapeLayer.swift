//
//  CAShapeLayer.swift
//  BsFoundation
//
//  Created by changrunze on 2023/7/4.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

import UIKit

public extension SwiftX where T: CAShapeLayer {
    
    func applyCorners(with rect: CGRect, radius: CGFloat, corners: UIRectCorner) {
        let bezierPath = UIBezierPath(roundedRect: rect,
                                      byRoundingCorners: corners,
                                      cornerRadii: [radius, radius])
        this.path = bezierPath.cgPath
        this.frame = rect
    }

}
