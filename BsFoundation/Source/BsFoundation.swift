//
//  BsFoundation.swift
//  BsFoundation
//
//  Created by crzorz on 2021/8/4.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import UIKit
import BsLogger

let logger = BsLogger(subsystem: "com.bald-studio.BsFoundation",
                      category: "BsFoundation")

public let BsApp = UIApplication.shared

// FIXME: 暂时忽略UIScene的情况
private var _BsWindow: UIWindow!
public var BsWindow: UIWindow {
    guard _BsWindow == nil else {
        return _BsWindow
    }
    
    var win = BsApp.delegate?.window
    if win != nil {
        _BsWindow = win!
        return _BsWindow
    }
    
    win = BsApp.windows.first
    if win != nil {
        _BsWindow = win!
        return _BsWindow
    }
    
    if let scene = BsApp.connectedScenes.first as? UIWindowScene {
        win = scene.windows.first
        if win != nil {
            _BsWindow = win!
            return _BsWindow
        }
    }
    
    fatalError("Can not fina main window")
}

public struct Bootstrap {
    public static func start(inital delegate: UIApplicationDelegate,
                             principal rootClass: UIViewController.Type,
                             _ filePath: String? = nil) {
        loadApplets(filePath)

        guard let delegate = delegate as? NSObject else {
            return
        }
        
        var win = delegate.value(forKey: "window") as? UIWindow
        if win == nil {
            let window = UIWindow(frame: UIScreen.main.bounds)
            delegate.setValue(window, forKey: "window")
            window.backgroundColor = .white
            window.makeKeyAndVisible()
            win = window
        }
        
        _BsWindow = win
        win!.rootViewController = rootClass.init()

    }
    
    private static func loadApplets(_ filePath: String? = nil) {
        guard let path = filePath ?? Bundle.main.path(forResource: "AppletRoutine",
                                                      ofType: "plist"),
              let xml = FileManager.default.contents(atPath: path)
        else { fatalError("路由数据路径识别失败") }
        
        guard let result = try? PropertyListSerialization.propertyList(from: xml,
                                                                       options: .mutableContainersAndLeaves,
                                                                       format: nil)
        else { fatalError("路由数据读取失败") }
        
        guard result is [[String: String]] else { fatalError("路由数据的格式异常") }
        let list = result as! [[String: String]]
        
        let manifests = list.compactMap {
            Manifest(id: $0["id"]!, name: $0["name"]!, version: $0["version"]!)
        }
        
        Context.registerApplets(with: manifests)

    }
}

