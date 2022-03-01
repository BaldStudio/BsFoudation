//
//  BsViewController.swift
//  BsFoundation
//
//  Created by crzorz on 2021/9/6.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import UIKit

open class BsViewController: UIViewController {

    open override var shouldAutorotate: Bool {
        children.first?.shouldAutorotate ?? super.shouldAutorotate
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        children.first?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
    }
    
    open override var childForStatusBarStyle: UIViewController? {
        children.first
    }
    
    open override var childForStatusBarHidden: UIViewController? {
        children.first
    }
    
    open override var childForHomeIndicatorAutoHidden: UIViewController? {
        children.first
    }
    
    open override var childForScreenEdgesDeferringSystemGestures: UIViewController? {
        children.first
    }

}
