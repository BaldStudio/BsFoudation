//
//  UIButton+.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/16.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

public extension UIButton {
    func iconFont(_ icon: any BsIconFont,
                  fontSize: CGFloat,
                  color: UIColor? = nil,
                  for state: UIControl.State = .normal) {
        let image = UIImage.iconFont(icon, fontSize: fontSize, color: color)
        setImage(image, for: state)
    }
}
