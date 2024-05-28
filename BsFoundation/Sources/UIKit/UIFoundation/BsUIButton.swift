//
//  BsUIButton.swift
//  BsFoundation
//
//  Created by 常润泽 on 2024/3/8.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

open class BsUIButton: UIButton {
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
