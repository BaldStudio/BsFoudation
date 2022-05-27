//
//  UIApplication.swift
//  BsFoundation
//
//  Created by crzorz on 2022/3/8.
//  Copyright © 2022 BaldStudio. All rights reserved.
//

import UIKit

private var _window: UIWindow? = nil

public let BsApp = UIApplication.shared

public let BsAppWindow = BsApp.bs.window!

public let BsAppIcon = BsApp.bs.icon!

public let BsAppBundle = Bundle.main

public extension SwiftPlus where T: UIApplication {
    
    var icon: UIImage! {
        UIImage(named: "AppIcon60x60")
    }
    
    var window: UIWindow! {
        if _window != nil { return _window }
                
        _window = BsApp.delegate?.window ?? nil
        if _window != nil { return _window }

        _window = BsApp.windows.first
        if _window != nil { return _window }

        if let scene = BsApp.connectedScenes.first as? UIWindowScene {
            _window = scene.windows.first
            if _window != nil { return _window }
        }
        
        fatalError("Can not find main window")
    }
    
}
