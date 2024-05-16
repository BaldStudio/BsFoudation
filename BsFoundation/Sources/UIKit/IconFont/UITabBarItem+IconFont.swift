//
//  UITabBarItem+IconFont.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/16.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

public extension UITabBarItem {
    func iconFont(_ icon: any BsIconFont,
                  fontSize: CGFloat,
                  color: UIColor? = nil,
                  for state: UIControl.State = .normal) {
        let icon = UIImage.iconFont(icon, fontSize: fontSize, color: color)
        if state == .selected {
            selectedImage = icon
        } else {
            image = icon
        }
    }
}
