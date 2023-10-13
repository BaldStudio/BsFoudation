//
//  UIViewController.swift
//  BsFoundation
//
//  Created by crzorz on 2022/6/4.
//  Copyright © 2022 BaldStudio. All rights reserved.
//

import UIKit
import SwiftUI

public extension SwiftX where T: UIViewController {
    
    @inlinable
    var root: UIViewController? {
        var parent = this.parent
        
        while let _parent = parent?.parent {
            parent = _parent
        }
        
        return parent
    }
    
    /// 判断是 push 或 present，然后执行对应的退出方法
    func showPrevoiusViewController() {
        if let navigationController = this.navigationController, navigationController.children.count > 1 {
            navigationController.popViewController(animated: true)
        } else {
            this.dismiss(animated: true)
        }
    }
}

//MARK: - SwiftUI

public extension SwiftX where T: UIViewController {
    
    @inlinable
    func showHostingView<Content: View>(_ view: Content) {
        let host = UIHostingController(rootView: view)
        this.addChild(host)
        this.view.addSubview(host.view)
        host.view.bs.edgesEqualToSuperview()
        host.didMove(toParent: this)
    }
    
}
