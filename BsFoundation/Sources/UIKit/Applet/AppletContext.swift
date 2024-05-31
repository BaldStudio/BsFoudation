//
//  AppletContext.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/30.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

public class AppletContext {
    var manifestsByName: [String: Applet.Manifest] = [:]
    
    var applets: [Applet] = []
    
    var currentApplet: Applet? { applets.last }
    
    public var navigationController: UINavigationController!
    
    public static let shared = AppletContext()
    private init() {}
}

public extension AppletContext {
    func registerApplet(_ manifest: Applet.Manifest) {
        manifestsByName[manifest.name] = manifest
    }
    
    func unregisterApplet(_ name: String) {
        manifestsByName[name] = nil
    }
    
    @discardableResult
    func startApplet(_ name: String, block: ((inout LaunchOptions) -> Void)? = nil) -> Applet? {
        defer {
            printStackData()
        }
        // TODO: 默认给个404的applet
        guard let target = lookupApplet(name) ?? createApplet(name) else {
            logger.error("未找到 Applet: \(name)")
            return nil
        }
                
        if let contentViewController = target.delegate?.contentViewController {
            contentViewController.moveToParent(target.appletController)
        }
        
        var options = LaunchOptions()
        if let block {
            block(&options)
        }
        let params = options.params ?? [:]

        if !target.isLaunched {
            target.delegate?.appletWillFinishLaunching(target, options: params)
        }

        pushApplet(target)

        if let currentApplet {
            currentApplet.delegate?.appletWillResignActive(currentApplet)
        }
        
        CATransaction.setCompletionBlock(options.completion)
        CATransaction.begin()
        navigationController.pushViewController(target.appletController,
                                                animated: options.animated)
        CATransaction.commit()
        
        if target.isLaunched {
            target.delegate?.appletDidBecomeActive(target)
        } else {
            target.delegate?.appletDidFinishLaunching(target)
            target.isLaunched = true
        }
        
        return target
    }
    
    @discardableResult
    func exitApplet(block: ((inout LaunchOptions) -> Void)? = nil) -> Applet? {
        defer {
            printStackData()
        }

        guard let applet = currentApplet else {
            return nil
        }

        var options = LaunchOptions()
        if let block {
            block(&options)
        }
                
        CATransaction.setCompletionBlock(options.completion)
        CATransaction.begin()
        navigationController.popToViewController(applet.appletController, animated: options.animated)
        CATransaction.commit()
        return popApplet()
    }

    @discardableResult
    func exitToApplet(_ name: String, block: ((inout LaunchOptions) -> Void)? = nil) -> [Applet] {
        defer {
            printStackData()
        }

        var options = LaunchOptions()
        if let block {
            block(&options)
        }
        
        guard let target = lookupApplet(name) else {
            logger.error("未找到 Applet: \(name)")
            return []
        }
        
        CATransaction.setCompletionBlock(options.completion)
        CATransaction.begin()
        navigationController.popToViewController(target.appletController, animated: options.animated)
        CATransaction.commit()
        return popToApplet(target)
    }
}

// MARK: -  Manage

extension AppletContext {
    func createApplet(_ name: String) -> Applet? {
        guard let manifest = manifestsByName[name],
              let appletClass = manifest.appletClass else {
            return nil
        }
        logger.debug("当前 Appelt 所在 Bundle 为：\(manifest.bundle)")
        let applet = appletClass.init()
        applet.manifest = manifest
        logger.debug("初始化 \(manifest.description)")
        return applet
    }
    
    func lookupApplet(_ name: String) -> Applet? {
        applets.first {
            $0.manifest.name == name
        }
    }
    
    func pushApplet(_ applet: Applet) {
        applets.append(applet)
    }
    
    @discardableResult
    func popApplet() -> Applet? {
        defer {
            printStackData()
        }
        guard let applet = currentApplet else {
            return nil
        }
        logger.debug("退出当前应用 \(applet.description)")
        applets.removeLast()
        if let delegate = applet.delegate {
            delegate.appletWillTerminate(applet)
        }
        return applet

    }

    @discardableResult
    func popToApplet(_ target: Applet) -> [Applet] {
        defer {
            printStackData()
        }
        var pops: [Applet] = []
        for applet in applets.reversed() {
            if applet == target {
                break
            }
            pops.append(applet)
            applets.removeLast()
            if let delegate = applet.delegate {
                delegate.appletWillTerminate(applet)
            }
        }
        return pops
    }
}

// MARK: -  LaunchOptions

public extension AppletContext {
    struct LaunchOptions {
        public var params: [String: Any]? = nil
        public var animated: Bool = true
        public var completion: (() -> Void)? = nil
    }
}

//MARK: - Debug

extension AppletContext {
    func printStackData() {
        logger.debug("当前应用栈 \(AppletContext.shared.applets)")
    }
}
