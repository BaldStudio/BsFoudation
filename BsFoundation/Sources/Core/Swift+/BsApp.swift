//
//  BsApp.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/16.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

public enum BsApp {
    static let shared = UIApplication.shared
        
    static let bundle: Bundle = Bundle.main

    static let id = Bundle.main.info(for: .id)
    static let name = Bundle.main.info(for: .displayName)
    static let version = Bundle.main.info(for: .version)
    
    static var isTestFlight: Bool {
        guard let appStoreReceiptURL = Bundle.main.appStoreReceiptURL else {
            return false
        }
        return appStoreReceiptURL.lastPathComponent == "sandboxReceipt"
    }
}

public extension BsApp {
    static var mainWindow: UIWindow? {
        if let window = shared.delegate?.window {
            return window
        }
                
        if #available(iOS 13.0, *) {
            if let scene = shared.connectedScenes.first as? UIWindowScene {
                return scene.windows.first
            }
        }
        return shared.windows.first
    }
    
    static var keyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            for scene in shared.connectedScenes where scene.activationState == .foregroundActive {
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
        }
        if let window = shared.keyWindow { return window }
        for window in shared.windows where window.isKeyWindow { return window }
        return nil
    }
    
    static var rootViewController: UIViewController? {
        mainWindow?.rootViewController
    }

    static var rootNavigationController: UINavigationController? {
        let root = rootViewController
        if let tab = root as? UITabBarController {
            return tab.selectedViewController as? UINavigationController
        }
        return root as? UINavigationController
    }
    
    static var topViewController: UIViewController? {
        func findTopViewController(by vc: UIViewController?) -> UIViewController? {
            var result = vc
            if let nav = vc as? UINavigationController {
                result = findTopViewController(by: nav.visibleViewController)
            }
            if let tab = vc as? UITabBarController {
                result = findTopViewController(by: tab.selectedViewController)
            }
            return result
        }
        var result = rootViewController
        while let presentedViewController = result?.presentedViewController {
            result = presentedViewController
        }
        return findTopViewController(by: result)
    }

    static var topNavigationController: UINavigationController? {
        topViewController?.navigationController
    }

    static func canOpenURL(_ url: URL) -> Bool {
        shared.canOpenURL(url)
    }

    static func openURL(_ url: URL,
                        options: [UIApplication.OpenExternalURLOptionsKey : Any] = [:],
                        completionHandler completion: BlockT<Bool>? = nil) {
        shared.open(url, options: options, completionHandler: completion)
    }

}
