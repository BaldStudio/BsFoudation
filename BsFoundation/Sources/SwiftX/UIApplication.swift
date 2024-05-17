//
//  UIApplication.swift
//  BsFoundation
//
//  Created by crzorz on 2022/3/8.
//  Copyright © 2022 BaldStudio. All rights reserved.
//

import UIKit

public var BsAppMainWindow: UIWindow? {
    if let window = BsApp.shared.delegate?.window {
        return window
    }
    if let scene = BsApp.shared.connectedScenes.first as? UIWindowScene {
        return scene.windows.first
    }
    return BsApp.shared.windows.first
}

public var BsAppKeyWindow: UIWindow? {
    for scene in BsApp.shared.connectedScenes where scene.activationState == .foregroundActive {
        if let windowScene = scene as? UIWindowScene {
            if #available(iOS 15.0, *), let keyWindow = windowScene.keyWindow {
                return keyWindow
            } else {
                for window in windowScene.windows where window.isKeyWindow {
                    return window
                }
            }
        }
    }
    for window in BsApp.shared.windows where window.isKeyWindow { return window }
    return nil
}

public var BsAppRootViewController: UIViewController? {
    BsAppMainWindow?.rootViewController
}

//public let BsAppIcon = BsApp.bs.icon

public let BsAppBundle = Bundle.main

public extension SwiftX where T: UIApplication {
        
    @inlinable
    var icon: UIImage? {
        UIImage(named: "AppIcon60x60")
    }
}
