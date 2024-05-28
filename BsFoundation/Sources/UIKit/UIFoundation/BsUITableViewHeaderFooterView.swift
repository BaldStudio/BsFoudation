//
//  BsUITableViewHeaderFooterView.swift
//  BsFoundation
//
//  Created by changrunze on 2023/11/29.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

open class BsUITableViewHeaderFooterView: UITableViewHeaderFooterView {
    deinit {
        logger.debug("\(classForCoder) -> deinit 🔥")
    }
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        onInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        onInit()
    }

    open func onInit() {

    }
}
