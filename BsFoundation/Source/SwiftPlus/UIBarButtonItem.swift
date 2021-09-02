//
//  UIBarButtonItem.swift
//  BsSwiftPlus
//
//  Created by crzorz on 2021/8/4.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import UIKit

public extension SwiftPlus where T: UIBarButtonItem {
    static var spacer: UIBarButtonItem {
        UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                        target: nil,
                        action: nil)
    }
    
    static func fixedSpacer(_ w: CGFloat = 16) -> UIBarButtonItem {
        let item = UIBarButtonItem(barButtonSystemItem: .fixedSpace,
                                   target: nil,
                                   action: nil)
        item.width = w
        return item
    }
}
