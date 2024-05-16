//
//  UIImageView+IconFont.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/16.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

public extension UIImageView {
    func iconFont(_ icon: any BsIconFont, fontSize: CGFloat, color: UIColor? = nil) {
        image = UIImage.iconFont(icon, fontSize: fontSize, color: color)
    }
    
    func iconFont(_ icon: any BsIconFont, imageSize: CGSize? = nil, color: UIColor? = nil) {
        image = UIImage.iconFont(icon, imageSize: imageSize ?? bounds.size, color: color)
    }
}
