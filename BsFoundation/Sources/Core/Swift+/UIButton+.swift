//
//  UIButton+.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/16.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

public extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State = .normal) {
        setBackgroundImage(color.asImage, for: state)
    }
}
