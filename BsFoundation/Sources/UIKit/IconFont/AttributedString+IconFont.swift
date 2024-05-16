//
//  AttributedString+IconFont.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/16.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

public extension NSAttributedString {
    static func iconFont(_ icon: any BsIconFont, fontSize: CGFloat, color: UIColor? = nil) -> NSAttributedString {
        var attributes = [NSAttributedString.Key: Any]()
        attributes[.font] = UIFont(iconFont: icon, size: fontSize)
        if let color {
            attributes[.foregroundColor] = color
        }
        return NSAttributedString(string: icon.unicode, attributes: attributes)
    }
}
