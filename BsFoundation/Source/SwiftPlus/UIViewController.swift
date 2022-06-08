//
//  UIViewController.swift
//  BsFoundation
//
//  Created by crzorz on 2022/6/4.
//  Copyright © 2022 BaldStudio. All rights reserved.
//

import UIKit
import SwiftUI

public extension SwiftPlus where T: UIViewController {
    
    @inlinable
    var root: UIViewController? {
        var parent = this.parent
        
        while let _parent = parent?.parent {
            parent = _parent
        }
        
        return parent
    }
    
}

//MARK: - SwiftUI

public extension SwiftPlus where T: UIViewController {
    
    @inlinable
    func showHostingView<Content: View>(_ view: Content) {
        let host = UIHostingController(rootView: view)
        this.addChild(host)
        this.view.addSubview(host.view)
        host.view.bs.edgesEqualToSuperview()
        host.didMove(toParent: this)
    }
    
}
