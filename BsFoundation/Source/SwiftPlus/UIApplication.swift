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

public let BsAppMainWindow = BsApp.bs.mainWindow!

public let BsAppKeyWindow = BsApp.bs.keyWindow

public let BsAppIcon = BsApp.bs.icon!

public let BsAppBundle = Bundle.main

public extension SwiftPlus where T: UIApplication {
        
    @inlinable
    var icon: UIImage! {
        UIImage(named: "AppIcon60x60")
    }
    
    var mainWindow: UIWindow! {
        guard _window == nil else { return _window }
                        
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
    
    var keyWindow: UIWindow {
        
        if #available(iOS 13.0, *) {
            for scene in this.connectedScenes {
                if scene.activationState == .foregroundActive,
                   let windowScene = scene as? UIWindowScene {
                    if #available(iOS 15.0, *),
                        let keyWindow = windowScene.keyWindow {
                        return keyWindow
                    }
                    else {
                        for window in windowScene.windows {
                            if window.isKeyWindow {
                                return window
                            }
                        }
                    }
                }
            }
        }
        else {
            if let window = this.keyWindow {
                return window
            }
            
            for window in this.windows {
                if window.isKeyWindow {
                    return window
                }
            }
        }
        
        fatalError("Can not find key window")
        
    }

}
