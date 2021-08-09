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
    
    static var navigationController = UINavigationController()
    
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
    static func start(applet id: String, closure: ((inout Context.Operation) -> Void)? = nil) -> Applet? {
        let app = lookup(appletBy: id) ?? appletManager.create(by: id)
        guard let toApp = app else { logger.debug("未找到applet: \(id)");  return nil }
        
        var param: Operation? = nil
        if let callout = closure {
            param = Operation()
            callout(&(param!))
        }
        
        let fromApp = appletManager.lastAppet

        if toApp.launched {
            toApp.willEnterForeground()
        }
        else {
            toApp.willFinishLaunching(options: param?.options)
        }
                
        appletManager.add(toApp)
                
        if let p = param, p.mode != Mode.none {
            let animated = p.animated ?? true
            CATransaction.setCompletionBlock(p.completion)
            CATransaction.begin()
            navigationController.pushViewController(toApp.root, animated: animated)
            CATransaction.commit()
        }
        
        fromApp?.didEnterBackground()
        
        if !toApp.launched {
            toApp.didFinishLaunching(options: param?.options)
            toApp.launched = true
        }
        
        if param?.mode == Mode.none {
            param?.completion?()
        }
        
        logger.debug("当前应用栈\(appletManager.applets)")
        logger.debug("当前后台应用栈\(appletManager.residentApplets)")
        return toApp
    }
    
    @discardableResult
    static func exitApp(_ id: String? = nil, closure: ((inout Operation) -> Void)? = nil) -> Applet? {
        
        var param: Operation? = nil
        if let callout = closure {
            param = Operation()
            callout(&(param!))
        }

        let animated = param?.animated ?? true
        
        if id == nil || id?.count == 0 {
            if let p = param {
                if p.mode == Mode.none {
                    p.completion?()
                }
                else {
                    CATransaction.setCompletionBlock(p.completion)
                    CATransaction.begin()
                    navigationController.popViewController(animated: animated)
                    CATransaction.commit()
                }
            }
            return appletManager.pop()
        }

        guard let toApp = lookup(appletBy: id!) else { return nil }
        
        toApp.willEnterForeground()
        for vc in navigationController.children.reversed() {
            if vc is AppletController, vc != toApp.root  {
                appletManager.pop()
            }
        }

        if let p = param {
            if p.mode == Mode.none {
                p.completion?()

            }
            else {
                CATransaction.setCompletionBlock(p.completion)
                CATransaction.begin()
                navigationController.popToViewController(toApp.root, animated: animated)
                CATransaction.commit()
            }
        }

        logger.debug("当前应用栈\(appletManager.applets)")
        logger.debug("当前后台应用栈\(appletManager.residentApplets)")
        return toApp
    }
    
    static func lookup(appletBy id: String) -> Applet? {
        appletManager.lookup(appletBy: id) ?? appletManager.lookup(residentAppletBy: id)
    }

}

public extension Context {
    enum Mode {
        case none
        case navigate
    }
    
    struct Operation {
        public var mode: Mode = .navigate
        public var options: [String: Any]? = nil
        public var animated: Bool? = true
        public var completion: (() -> Void)? = nil
    }
}
