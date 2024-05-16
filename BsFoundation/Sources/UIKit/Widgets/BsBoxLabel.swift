//
//  BsBoxLabel.swift
//  BsFoundation
//
//  Created by crzorz on 2022/3/3.
//  Copyright © 2022 BaldStudio. All rights reserved.
//

import UIKit

open class BsBoxLabel: UILabel {
    open var textInsets: UIEdgeInsets = .zero
    
    open override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
    
    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insets = textInsets
        var rect = super.textRect(forBounds: bounds.inset(by: insets),
                                  limitedToNumberOfLines: numberOfLines)
        
        rect.origin.x -= insets.left
        rect.origin.y -= insets.top
        rect.size.width += (insets.left + insets.right)
        rect.size.height += (insets.top + insets.bottom)
        return rect
    }
}
