//
//  BsProxy.swift
//  BsUIKit
//
//  Created by crzorz on 2022/3/4.
//  Copyright © 2022 BaldStudio. All rights reserved.
//

import Foundation

open class BsProxy: NSObject {
        
    open weak var target: AnyObject?

    public convenience init(_ target: AnyObject?) {
        self.init()
        self.target = target
    }
        
    open override func forwardingTarget(for aSelector: Selector!) -> Any? {
        target?.responds(to: aSelector) == true ? target : super.forwardingTarget(for: aSelector)
    }
    
    open override func responds(to aSelector: Selector!) -> Bool {
        target?.responds(to: aSelector) == true || super.responds(to: aSelector)
    }
    
}
