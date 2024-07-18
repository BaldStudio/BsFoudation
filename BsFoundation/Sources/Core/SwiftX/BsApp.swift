//
//  BsApp.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/16.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

public enum BsApp {
    public static let shared = UIApplication.shared
        
    public static let bundle: Bundle = Bundle.main

    public static let id = Bundle.main.info(for: .id)
    public static let name = Bundle.main.info(for: .displayName)
    public static let version = Bundle.main.info(for: .version)
    
    public static var isTestFlight: Bool {
        guard let appStoreReceiptURL = Bundle.main.appStoreReceiptURL else {
            return false
        }
        return appStoreReceiptURL.lastPathComponent == "sandboxReceipt"
    }
    
    public static let connectedScenes: Set<UIScene> = shared.connectedScenes
    
    public static let windowScene: UIWindowScene? = connectedScenes.first as? UIWindowScene
}

public extension BsApp {
    static var windows: [UIWindow] {
        if let scene = windowScene {
            return scene.windows
        }
        return shared.windows
    }
    
    static var mainWindow: UIWindow? {
        if let window = shared.delegate?.window {
            return window
        }
        return windows.first
    }
    
    static var keyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            for scene in connectedScenes where scene.activationState == .foregroundActive {
                guard let windowScene = scene as? UIWindowScene else { continue }
                if #available(iOS 15.0, *), let keyWindow = windowScene.keyWindow {
                    return keyWindow
                } else {
                    for window in windowScene.windows where window.isKeyWindow {
                        return window
                    }
                }
            }
        } else {
            if let window = shared.keyWindow { return window }
        }
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

    static func open(_ url: URL,
                     options: [UIApplication.OpenExternalURLOptionsKey: Any] = [:],
                     completionHandler completion: BlockT<Bool>? = nil) {
        shared.open(url, options: options, completionHandler: completion)
    }
}
