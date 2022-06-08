//
//  UIResponder.swift
//  BsFoundation
//
//  Created by crzorz on 2022/6/6.
//  Copyright © 2022 BaldStudio. All rights reserved.
//

import UIKit

public extension SwiftPlus where T: UIResponder {
    
    func nearest<T>(ofKind kind: T.Type) -> T? {
        guard !this.isKind(of: kind as! AnyClass) else {
            return this as? T
        }
        
        return this.next?.bs.nearest(ofKind: kind)
    }
    
}
