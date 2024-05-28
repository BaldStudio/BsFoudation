//
//  UIViewController+.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/16.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

import SwiftUI

public extension UIViewController {
    var ancestor: UIViewController? {
        var parent = self.parent
        while let _parent = parent?.parent {
            parent = _parent
        }
        return parent
    }
    
    /// 判断是 push 或 present，然后执行对应的退出方法
    @inlinable
    func backwards() {
        if let navigationController, navigationController.children.count > 1 {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
    
    func move(toParent parent: UIViewController) {
        parent.addChild(self)
        parent.view.addSubview(view)
        self.didMove(toParent: parent)
    }
    
    func removeFromParentIfNeeded() {
        guard parent != nil else { return }
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}

//MARK: - SwiftUI

public extension UIViewController {
    func addChild<Content: View>(_ content: Content) {
        let host = UIHostingController(rootView: content)
        addChild(host)
        view.addSubview(host.view)
        host.view.edgesEqualToSuperview()
        host.didMove(toParent: self)
    }
}
