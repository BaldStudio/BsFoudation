//
//  AppletManager.swift
//  BsFoundation
//
//  Created by crzorz on 2021/7/19.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import UIKit

class AppletManager: Service {
    var applets: ContiguousArray<Applet> = []
    /// TODO: 改成集合类型
    var residentApplets: ContiguousArray<Applet> = []

    var manifestsById: [String: Manifest] = [:]
    
    var lastAppet: Applet? {
        applets.last
    }

    func create(by id: String) -> Applet? {
        guard let manifest = manifestsById[id],
            let cls = NSClassFromString("\(manifest.bundle).\(manifest.name)") as? Applet.Type
        else {
            return nil
        }
        
        cls.bundleName = manifest.bundle
        logger.debug("当前 Appelt 所在 Bundle 为：\(cls.bundleName)")
        let applet = cls.init()
        applet.manifest = manifest
        if !applet.shouldTerminate {
            add(resident: applet)
        }
        logger.debug("初始化 \(manifest.description)")
        return applet
    }
    
    func lookup(applet id: String) -> Applet? {
        for app in applets {
            if let m = app.manifest, m.id == id {
                return app
            }
        }
        
        return nil
    }
        
    func push(_ applet: Applet) {
        defer {
            logger.debug("当前应用栈 \(applets)")
            logger.debug("当前后台应用栈 \(residentApplets)")
        }

        applet.willFinishLaunching()
        add(applet)
                
        applet.didFinishLaunching()
    }
    
    @discardableResult
    func pop(to target: Applet? = nil) -> Applet? {
        if let target = target {
            for a in applets.reversed() {
                if a == target {
                    target.willEnterForeground()
                    return target
                }
                
                if a.shouldTerminate {
                    a.willTerminate()
                }
                else {
                    a.didEnterBackground()
                }
                applets.removeLast()
            }
            
            return target
        }
        
        guard let applet = lastAppet else {
            logger.debug("当前应用栈 \(applets)")
            return nil
        }
        
        defer {
            logger.debug("当前应用栈 \(applets)")
            logger.debug("当前后台应用栈 \(residentApplets)")
        }
        
        logger.debug("退出当前应用 \(applet.description)")
                
        applets.removeLast()
        if applet.shouldTerminate {
            applet.willTerminate()
        }
        else {
            applet.didEnterBackground()
        }
        
        lastAppet?.willEnterForeground()
        return applet
    }
    
    func add(_ applet: Applet) {
        applets.append(applet)
    }
    
}

extension AppletManager {
    func lookup(residentApplet id: String) -> Applet? {
        for app in residentApplets {
            if let m = app.manifest, m.id == id {
                return app
            }
        }
        return nil
    }

    func add(resident a: Applet) {
        residentApplets.append(a)
    }
    
    func remove(resident a: Applet) {
        let temp = residentApplets
        for (idx, item) in temp.enumerated() {
            if item == a {
                residentApplets.remove(at: idx)
                return
            }
        }
    }
}
