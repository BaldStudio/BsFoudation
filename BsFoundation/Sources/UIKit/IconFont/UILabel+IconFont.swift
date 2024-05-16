//
//  UILabel+IconFont.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/16.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

public extension UILabel {
    func iconFont(_ icon: any BsIconFont, fontSize: CGFloat, color: UIColor? = nil) {
        attributedText = NSAttributedString.iconFont(icon, fontSize: fontSize, color: color)
    }
}
