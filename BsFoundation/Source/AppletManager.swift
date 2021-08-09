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
    var residentApplets: ContiguousArray<Applet> = []

    var manifestsById: [String: Manifest] = [:]
    
    var lastAppet: Applet? {
        applets.last
    }

    func create(by id: String) -> Applet? {
        guard let manifest = manifestsById[id],
            let cls = NSClassFromString(manifest.name) as? Applet.Type
        else {
            return nil
        }
        
        let applet = cls.init()
        applet.manifest = manifest
        if !applet.shouldTerminate {
            add(resident: applet)
        }
        logger.debug("初始化 \(manifest.name)")
        return applet
    }
    
    func lookup(appletBy id: String) -> Applet? {
        for app in applets {
            if let m = app.manifest, m.id == id {
                return app
            }
        }
        
        return nil
    }
        
    func push(_ applet: Applet) {
        defer {
            logger.debug("当前应用栈\(applets)")
            logger.debug("当前后台应用栈\(residentApplets)")
        }

        applet.willFinishLaunching()
        add(applet)
                
        applet.didFinishLaunching()
    }
    
    @discardableResult
    func pop() -> Applet? {
        guard let applet = lastAppet else {
            logger.debug("当前应用栈\(applets)是空的啊")
            return nil
        }
        
        defer {
            logger.debug("当前应用栈\(applets)")
            logger.debug("当前后台应用栈\(residentApplets)")
        }
        
        logger.debug("退出当前应用\(applet)")
                
        applets.removeLast()
        if (applet.shouldTerminate) {
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
    func lookup(residentAppletBy id: String) -> Applet? {
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
