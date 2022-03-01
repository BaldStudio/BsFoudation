//
//  Context.swift
//  BsFoundation
//
//  Created by crzorz on 2021/7/19.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import UIKit

public struct Context: Service {
    
    static let appletManager = AppletManager()

    init() {
        
    }
    
    public static let shared = Context()
}

public extension Context {
    
    static var tabBarController: BsTabBarController!
    static var navigationController: BsNavigationController!
    
    static var currentApplet: Applet? {
        appletManager.lastAppet
    }
    
    static func registerApplets(with manifests: [Manifest]) {
        for m in manifests {
            appletManager.manifestsById[m.id] = m
        }
    }
    
    static var appletManifests: [Manifest] {
        [Manifest](appletManager.manifestsById.values)
    }
    
    @discardableResult
    static func start(applet id: String, closure: ((inout Option) -> Void)? = nil) -> Applet? {
        let app = lookup(applet: id) ?? appletManager.create(by: id)
        guard let toApp = app else { logger.debug("未找到 Applet: \(id)");  return nil }
        
        var options: Option? = nil
        if let callout = closure {
            options = Option()
            callout(&(options!))
        }
        
        let fromApp = appletManager.lastAppet

        if toApp.launched {
            toApp.willEnterForeground()
        }
        else {
            toApp.willFinishLaunching(options: options?.params)
        }
                
        appletManager.add(toApp)
                
        if options?.mode != Mode.none {
            let animated = options?.animated ?? true
            CATransaction.setCompletionBlock(options?.completion)
            CATransaction.begin()
            navigationController?.pushViewController(toApp.root, animated: animated)
            CATransaction.commit()
        }
        
        fromApp?.didEnterBackground()
        
        if !toApp.launched {
            toApp.didFinishLaunching(options: options?.params)
            toApp.launched = true
        }
        
        if options?.mode == Mode.none {
            options?.completion?()
        }
        
        logger.debug("当前应用栈 \(appletManager.applets)")
        logger.debug("当前后台应用栈 \(appletManager.residentApplets)")
        return toApp
    }
    
    @discardableResult
    static func exit(toApplet id: String? = nil, closure: ((inout Option) -> Void)? = nil) -> Applet? {
        
        var options: Option? = nil
        if let callout = closure {
            options = Option()
            callout(&(options!))
        }

        let animated = options?.animated ?? true
        
        if id == nil || id?.count == 0 {
            if options?.mode == Mode.none {
                options?.completion?()
            }
            else {
                CATransaction.setCompletionBlock(options?.completion)
                CATransaction.begin()
                navigationController?.popViewController(animated: animated)
                CATransaction.commit()
            }
            return appletManager.pop()
        }

        guard let target = lookup(applet: id!) else { return nil }
        
        appletManager.pop(to: target)
        
        if options?.mode == Mode.none {
            options?.completion?()
        }
        else {
            CATransaction.setCompletionBlock(options?.completion)
            CATransaction.begin()
            navigationController?.popToViewController(target.root, animated: animated)
            CATransaction.commit()
        }

        logger.debug("当前应用栈 \(appletManager.applets)")
        logger.debug("当前后台应用栈 \(appletManager.residentApplets)")
        return target
    }
    
    static func lookup(applet id: String) -> Applet? {
        appletManager.lookup(applet: id) ?? appletManager.lookup(residentApplet: id)
    }

}

public extension Context {
    enum Mode {
        case none
        case navigate
    }
    
    struct Option {
        public var mode: Mode = .navigate
        public var params: [String: Any]? = nil
        public var animated: Bool? = true
        public var completion: (() -> Void)? = nil
    }
}
