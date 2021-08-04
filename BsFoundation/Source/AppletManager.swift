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
    var pendingApplets: ContiguousArray<Applet> = []

    var appletsById: [String: [Manifest.Key: String]] = [:]
    
    func create(by id: String) -> Applet? {
        guard let conf = appletsById[id],
            let name = conf[.name],
            let cls = NSClassFromString(name) as? Applet.Type
        else {
            return nil
        }

        return cls.init()
    }
    
    func find(appletBy id: String, createIfNotExist flag: Bool? = false) -> Applet? {
        for app in applets.reversed() {
            if app.manifest.id == id {
                return app
            }
        }
        
        var app = find(pendingAppletBy: id)
        
        if (app == nil && flag == true) {
            app = create(by: id)
        }
        
        return app

    }
    
    func find(pendingAppletBy id: String) -> Applet? {
        for app in pendingApplets {
            if app.manifest.id == id {
                return app
            }
        }
        return nil
    }
    
    func push(applet: Applet) {

        applet.willFinishLaunching()
        add(applet)
        
        if applet == find(pendingAppletBy: applet.manifest.id) {
            remove(pending: applet)
        }
        
        applet.didFinishLaunching()
        
        logger.debug("当前应用栈\(applets)")
        logger.debug("当前后台应用栈\(pendingApplets)")
    }
    
    func pop() {
        guard let app = lastAppet else {
            fatalError()
        }
        
        logger.debug("退出当前应用\(app)")
                
        applets.removeLast()
        if (app.shouldTerminate) {
            app.willTerminate()
        }
        else {
            add(pending: app)
            app.didEnterBackground()
        }

        lastAppet?.willEnterForeground()
        
        logger.debug("当前应用栈\(applets)")
        logger.debug("当前后台应用栈\(pendingApplets)")
    }

}

extension AppletManager {
    
    func add(_ a: Applet) {
        applets.append(a)
    }
        
    var lastAppet: Applet? {
        applets.last
    }
    
    func add(pending a: Applet) {
        pendingApplets.append(a)
        a.state = .pending
    }
    
    func remove(pending a: Applet) {
        let temp = pendingApplets
        for (idx, item) in temp.enumerated() {
            if item == a {
                pendingApplets.remove(at: idx)
                a.state = .normal
                return
            }
        }
    }
}
