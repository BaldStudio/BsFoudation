//
//  BsView.swift
//  BsFoundation
//
//  Created by crzorz on 2021/9/6.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import UIKit

@IBDesignable
open class BsView: UIView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {

    }
}

