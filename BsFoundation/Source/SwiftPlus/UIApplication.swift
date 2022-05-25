//
//  UIApplication.swift
//  BsFoundation
//
//  Created by crzorz on 2022/3/8.
//  Copyright © 2022 BaldStudio. All rights reserved.
//

import Foundation

public extension SwiftPlus where T: UIApplication {
    
    var icon: UIImage? {
        UIImage(named: "AppIcon60x60")
    }
    
}

public let BsApp = UIApplication.shared

private var _BsAppWindow: UIWindow? = nil
public var BsAppWindow: UIWindow! {
    if _BsAppWindow != nil {
        return _BsAppWindow
    }
    
    var window = BsApp.delegate?.window ?? nil
    if window != nil {
        _BsAppWindow = window
        return window
    }

    window = BsApp.windows.first
    if window != nil {
        _BsAppWindow = window
        return window
    }

    if let scene = BsApp.connectedScenes.first as? UIWindowScene {
        window = scene.windows.first
        if window != nil {
            _BsAppWindow = window
            return window
        }
    }
    
    fatalError("Can not find main window")
}
