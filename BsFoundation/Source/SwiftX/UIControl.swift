//
//  UIControl.swift
//  BsFoundation
//
//  Created by changrunze on 2023/8/9.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

private struct RuntimeKey {
    static var touchUpInside = 0
}

// MARK: - Touch Actions

public extension SwiftX where T: UIControl {
    
    func onTouchUpInside(_ action: @escaping BlockT<UIControl>) {
        this.touchUpInsideAction = action
        this.removeTarget(this, action: #selector(this.bs_onTouchUpInsideAction), for: .touchUpInside)
        this.addTarget(this, action: #selector(this.bs_onTouchUpInsideAction), for: .touchUpInside)
    }
    
}

private extension UIControl {
    
    var touchUpInsideAction: BlockT<UIControl>? {
        get {
            value(forAssociated: &RuntimeKey.touchUpInside)
        }
        set {
            set(associate: newValue, for: &RuntimeKey.touchUpInside)
        }
    }
    
    @objc
    func bs_onTouchUpInsideAction() {
        touchUpInsideAction?(self)
    }
    
}
