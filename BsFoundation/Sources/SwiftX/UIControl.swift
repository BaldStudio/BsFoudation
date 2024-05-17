//
//  UIControl.swift
//  BsFoundation
//
//  Created by changrunze on 2023/8/9.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

private struct RuntimeKey {
    static var touchUpInside = 0
    static var valueChanged = 0
}

// MARK: - Touch Actions

public extension BaldStudio where T: UIControl {
    
    func onTouchUpInside(_ action: @escaping BlockT<UIControl>) {
        this.touchUpInsideAction = action
        this.removeTarget(this, action: #selector(this.bs_onTouchUpInsideAction), for: .touchUpInside)
        this.addTarget(this, action: #selector(this.bs_onTouchUpInsideAction), for: .touchUpInside)
    }
    
    func onValueChanged(_ action: @escaping BlockT<UIControl>) {
        this.valueChangedAction = action
        this.removeTarget(self, action: #selector(this.bs_onValueChangedAction), for: .valueChanged)
        this.addTarget(self, action: #selector(this.bs_onValueChangedAction), for: .valueChanged)
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
    
    var valueChangedAction: BlockT<UIControl>? {
        get {
            value(forAssociated: &RuntimeKey.valueChanged)
        }
        set {
            set(associate: newValue, for: &RuntimeKey.valueChanged)
        }
    }

    @objc
    func bs_onTouchUpInsideAction() {
        touchUpInsideAction?(self)
    }
    
    @objc
    func bs_onValueChangedAction() {
        valueChangedAction?(self)
    }
}
