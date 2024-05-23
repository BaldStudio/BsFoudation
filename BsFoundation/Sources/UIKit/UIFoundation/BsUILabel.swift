//
//  BsUILabel.swift
//  BsFoundation
//
//  Created by 常润泽 on 2024/3/8.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

open class BsUILabel: UILabel {
    deinit {
        logger.debug("\(classForCoder) -> deinit 🔥")
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    open func commonInit() {

    }
    
}
