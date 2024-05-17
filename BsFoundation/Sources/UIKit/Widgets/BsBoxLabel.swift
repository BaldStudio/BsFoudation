//
//  BsBoxLabel.swift
//  BsFoundation
//
//  Created by changrunze on 2023/6/16.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

@IBDesignable
open class BsBoxLabel: BsUILabel {
    open override func commonInit() {
        super.commonInit()
        applyingFixed()
    }

    open var textInsets: UIEdgeInsets = .zero {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    open override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
    
    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insets = textInsets
        var rect = super.textRect(forBounds: bounds.inset(by: insets),
                                  limitedToNumberOfLines: numberOfLines)
        rect.size.width += (insets.left + insets.right)
        rect.size.height += (insets.top + insets.bottom)
        return rect
    }
}
