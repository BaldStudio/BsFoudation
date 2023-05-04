//
//  UIControl.swift
//  BsFoundation
//
//  Created by changrunze on 2023/8/9.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

import UIKit

// MARK: - Touch Actions

private extension UIControl {
    struct AssociateKey {
        static var touchUpInside = 0
    }
    
    var touchUpInsideAction: SwiftX.TouchUpInsideAction? {
        get {
            value(forAssociated: &AssociateKey.touchUpInside)
        }
        set {
            set(associate: newValue, for: &AssociateKey.touchUpInside)
        }
    }
    
    @objc
    func bs_onTriggerTouchUpInsideAction() {
        touchUpInsideAction?(self)
    }
}

public extension SwiftX where T: UIControl {
    typealias TouchUpInsideAction = (UIControl) -> Void
    
    func onTouchUpInside(_ action: @escaping TouchUpInsideAction) {
        this.touchUpInsideAction = action
        this.removeTarget(this, action: #selector(T.bs_onTriggerTouchUpInsideAction), for: .touchUpInside)
        this.addTarget(this, action: #selector(T.bs_onTriggerTouchUpInsideAction), for: .touchUpInside)
    }
}
