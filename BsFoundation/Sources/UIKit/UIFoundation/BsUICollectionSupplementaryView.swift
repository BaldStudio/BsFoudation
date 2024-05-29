//
//  BsUICollectionSupplementaryView.swift
//  BsFoundation
//
//  Created by 常润泽 on 2023/12/8.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

open class BsUICollectionSupplementaryView: UICollectionReusableView {
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
