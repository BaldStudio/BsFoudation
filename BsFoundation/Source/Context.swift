//
//  Context.swift
//  BsFoundation
//
//  Created by crzorz on 2021/7/19.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import UIKit

public struct Context: Service {
    let appletManager = AppletManager()

    init() {
        
    }
    
    public static let shared = Context()
}

public extension Context {
    
    static var navigationController = UINavigationController()
    
    static var currentApplet: Applet? {
        shared.appletManager.lastAppet
    }
    
    static func setApplets(_ data: [String: [Manifest.Key: String]]) {
        shared.appletManager.appletsById = data
    }
    
    static func start(applet id: String, closure: ((inout Context.Operation) -> Void)? = nil) {
        let app = shared.appletManager.find(appletBy: id, createIfNotExist: true)
        guard let toApp = app else { BsLog.debug("未找到applet: \(id)");  return }
        
        var param: Operation? = nil
        if let callout = closure {
            param = Operation()
            callout(&(param!))
        }
        
        if toApp.state == .pending {
            toApp.willEnterForeground()
        }
        else {
            toApp.willFinishLaunching(options: param?.options)
        }

        let fromApp = shared.appletManager.lastAppet
        shared.appletManager.add(toApp)
                    
        let animated = param?.animated ?? true
//        if param?.mode == .modal {
//            let lastNav = navigation
//            if let nav = toApp.root as? UINavigationController {
//                shared.navigationStack.append(nav)
//            }
//            lastNav.present(toApp.root, animated: animated, completion: param?.completion)
//        }
//        else if param?.launchMode == .custom {
//
//        }
//        else {
            CATransaction.setCompletionBlock(param?.completion)
            CATransaction.begin()
            navigationController.pushViewController(toApp.controller, animated: animated)
            CATransaction.commit()
//        }
        
        fromApp?.didEnterBackground()
        
        if toApp.state == .pending {
            shared.appletManager.remove(pending: toApp)
        }
        else {
            toApp.didFinishLaunching(options: param?.options)
        }
        
        BsLog.debug("当前应用栈\(shared.appletManager.applets)")
        BsLog.debug("当前后台应用栈\(shared.appletManager.pendingApplets)")

    }
    
    static func exitApp(_ id: String? = nil, closure: ((inout Operation) -> Void)? = nil) {
        
        var param: Operation? = nil
        if let callout = closure {
            param = Operation()
            callout(&(param!))
        }

        let animated = param?.animated ?? true
        
        if id == nil || id?.count == 0 {
            navigationController.popViewController(animated: animated)
            shared.appletManager.pop()
            return
        }

        guard let toApp = shared.appletManager.find(appletBy: id!) else { return }
        
        toApp.willEnterForeground()
        for vc in navigationController.children.reversed() {
            if vc.applet != nil, vc != toApp.controller  {
                shared.appletManager.pop()
            }
        }

        navigationController.popToViewController(toApp.controller, animated: animated)
        
        BsLog.debug("当前应用栈\(shared.appletManager.applets)")
        BsLog.debug("当前后台应用栈\(shared.appletManager.pendingApplets)")
    }
    
}

public extension Context {
    struct Operation {
        public enum Mode {
            case `default`
            case modal
            case custom // TODO
        }
        
        public var mode: Mode? = .default
        public var options: [String: Any]? = nil
        public var animated: Bool? = true
        public var completion: (() -> Void)? = nil
    }
}
