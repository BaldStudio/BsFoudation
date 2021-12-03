//
//  BsNavigationController.swift
//  BsFoundation
//
//  Created by crzorz on 2021/8/12.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import UIKit

open class BsNavigationController: UINavigationController {
            
    open override var shouldAutorotate: Bool {
        topViewController?.shouldAutorotate ?? super.shouldAutorotate
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        topViewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
    }
    
    open override var childForStatusBarStyle: UIViewController? {
        topViewController
    }
    
    open override var childForStatusBarHidden: UIViewController? {
        topViewController
    }

}
