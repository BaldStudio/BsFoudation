//
//  NavigationController.swift
//  BsFoundation
//
//  Created by crzorz on 2021/8/12.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import UIKit

open class NavigationController: UINavigationController {
    
    open func push(_ viewController: UIViewController) {
        pushViewController(viewController, animated: true)
    }
    
    open func pop() -> UIViewController? {
        popViewController(animated: true)
    }

}
