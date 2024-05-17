//
//  UIVisualEffectView+.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/17.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

public extension UIVisualEffectView {
    static func blur(style: UIBlurEffect.Style = .prominent) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
}

