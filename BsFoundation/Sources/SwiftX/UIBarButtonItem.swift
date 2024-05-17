//
//  UIBarButtonItem.swift
//  BsSwiftX
//
//  Created by crzorz on 2021/8/4.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import UIKit

public extension BaldStudio where T: UIBarButtonItem {
    @inlinable
    static var spacer: UIBarButtonItem {
        UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                        target: nil,
                        action: nil)
    }
    
    @inlinable
    static func fixedSpacer(_ w: CGFloat = 16) -> UIBarButtonItem {
        let item = UIBarButtonItem(barButtonSystemItem: .fixedSpace,
                                   target: nil,
                                   action: nil)
        item.width = w
        return item
    }
}
