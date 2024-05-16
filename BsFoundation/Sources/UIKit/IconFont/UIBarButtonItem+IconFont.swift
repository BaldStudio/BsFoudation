//
//  UIBarButtonItem+IconFont.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/16.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

public extension UIBarButtonItem {
    func iconFont(_ icon: any BsIconFont, fontSize: CGFloat, color: UIColor? = nil) {
        image = UIImage.iconFont(icon, fontSize: fontSize, color: color)
    }
}
