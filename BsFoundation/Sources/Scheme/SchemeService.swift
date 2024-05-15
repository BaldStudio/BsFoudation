//
//  SchemeService.swift
//  BsFoundation
//
//  Created by crzorz on 2022/12/29.
//  Copyright © 2022 BaldStudio. All rights reserved.
//

import UIKit

open class SchemeHandler {
    public required init() {}
    
    class func canOpenURL(_ url: URL) -> Bool { false }
    func openURL(_ url: URL) {}
}

public class SchemeService {
    
    var handlerClasses: [SchemeHandler.Type] = []
    private(set) var lastURL: URL?
    
    func registerHandlerClass(_ handlerClass: SchemeHandler.Type) {
        handlerClasses.append(handlerClass)
    }
    
    func unregisterHandlerClass(_ handlerClass: SchemeHandler.Type) {
        handlerClasses.removeAll { $0 == handlerClass }
    }
    
    func canHandleURL(_ url: URL) -> Bool {
        for cls in handlerClasses {
            if cls.canOpenURL(url) {
                return true
            }
        }
        return false
    }

    func handleURL(url: URL, userInfo: [String: Any]) {
        lastURL = url
        
        for cls in handlerClasses {
            if !cls.canOpenURL(url) { continue }
            let handler = cls.init()
            handler.openURL(url)
        }
    }
    
}
