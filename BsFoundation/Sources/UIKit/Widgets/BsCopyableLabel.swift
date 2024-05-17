//
//  BsCopyableLabel.swift
//  BsFoundation
//
//  Created by changrunze on 2023/6/16.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

@IBDesignable
open class BsCopyableLabel: BsUILabel {
    open var longPressGesture: UILongPressGestureRecognizer!
    
    open var copyItemTitle = "Copy"
    
    open override func commonInit() {
        super.commonInit()
        isUserInteractionEnabled = true
        
        longPressGesture = UILongPressGestureRecognizer(target: self,
                                                        action: #selector(onLongPress(_:)))
        longPressGesture.minimumPressDuration = 0.5
        addGestureRecognizer(longPressGesture)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onMenuDidHide(_:)),
                                               name: UIMenuController.didHideMenuNotification,
                                               object: self)
    }
    
    open override var canBecomeFirstResponder: Bool { true }
    
    open override func canPerformAction(_ action: Selector,
                                        withSender sender: Any?) -> Bool {
        action == #selector(onCopy(_:))
    }
}

@objc
extension BsCopyableLabel {
    open func onCopy(_ sender: UIMenuItem) {
        UIPasteboard.general.string = text
    }
    
    open func onLongPress(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else { return }
        guard canBecomeFirstResponder else { return }
        
        becomeFirstResponder()
        
        let copy = UIMenuItem(title: copyItemTitle, action: #selector(onCopy(_:)))
        UIMenuController.shared.menuItems = [copy]
        if #available(iOS 13.0, *) {
            UIMenuController.shared.showMenu(from: self, rect: self.bounds)
        } else {
            UIMenuController.shared.setTargetRect(self.bounds, in: self)
            UIMenuController.shared.setMenuVisible(true, animated: true)
        }
    }
    
    private func onMenuDidHide(_ note: Notification) {
        guard let obj = note.object as? Self, obj == self else { return }
        guard isFirstResponder else { return }
        
        resignFirstResponder()
    }
}
