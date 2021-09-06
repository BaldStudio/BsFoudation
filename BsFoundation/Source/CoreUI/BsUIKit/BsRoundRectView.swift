//
//  BsRoundRectView.swift
//  BsFoundation
//
//  Created by crzorz on 2021/9/6.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import UIKit

@IBDesignable
open class BsRoundRectView: BsView {

    @IBInspectable
    open var cornerRadius: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        var radius = min(cornerRadius, bounds.height / 2)
        radius = max(0, radius)
        layer.cornerRadius = radius
    }
    
    override func commonInit() {
        layer.masksToBounds = true
    }
}
