//
//  UIResponder.swift
//  BsFoundation
//
//  Created by crzorz on 2022/6/6.
//  Copyright © 2022 BaldStudio. All rights reserved.
//

import UIKit

public extension SwiftX where T: UIResponder {
    
    func nearest<Responder>(ofKind kind: Responder.Type) -> Responder? {
        guard !this.isKind(of: kind as! AnyClass) else {
            return this as? Responder
        }
        
        return this.next?.bs.nearest(ofKind: kind)
    }
    
}
