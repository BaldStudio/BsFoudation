//
//  BsDivideLine.swift
//  BsFoundation
//
//  Created by changrunze on 2023/9/20.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

open class BsDivideLine: BsUIView {    
    open override func commonInit() {
        backgroundColor = UIColor(0xD8D8D8)
    }
    
    open override var intrinsicContentSize: CGSize {
        [UIView.noIntrinsicMetric, Design.Height.line]
    }
}
