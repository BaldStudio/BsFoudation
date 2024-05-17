//
//  BsUICollectionViewCell.swift
//  BsFoundation
//
//  Created by changrunze on 2023/8/3.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

open class BsUICollectionViewCell: UICollectionViewCell {
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
