//
//  BsUITableViewCell.swift
//  BsFoundation
//
//  Created by changrunze on 2023/8/3.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

open class BsUITableViewCell: UITableViewCell {
    deinit {
        logger.debug("\(classForCoder) -> deinit 🔥")
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        onInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        onInit()
    }
    
    open func onInit() {
        
    }
}
