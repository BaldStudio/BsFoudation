//
//  BsUIControl.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/22.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

import UIKit

open class BsUIControl: UIControl {
    deinit {
        logger.debug("\(classForCoder) -> deinit 🔥")
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        onInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        onInit()
    }
    
    open func onInit() {

    }
}
