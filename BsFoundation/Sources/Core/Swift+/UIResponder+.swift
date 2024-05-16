//
//  UIResponder+.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/16.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

import Foundation

public extension UIResponder {
    func nearest<Node: UIResponder>(ofKind kind: Node.Type) -> Node? {
        guard !isKind(of: kind) else {
            return self as? Node
        }
        return next?.nearest(ofKind: kind)
    }
}
