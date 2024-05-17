//
//  UIColor.swift
//  BsSwiftX
//
//  Created by crzorz on 2021/7/16.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import UIKit

extension UIColor {
        
    /// rgb color, value limit 0 - 255
}

public extension BaldStudio where T: UIColor {
    
    
    static func dynamic(light: T, dark: T) -> T {
        if #available(iOS 13.0, *) {
            return T {
                let isLight = ($0.userInterfaceStyle == .light)
                return isLight ? light : dark
            }
        }
        return light
    }
        
    /// 随机色
    static var random: UIColor {
        UIColor(red: .random(in: 0...1),
                green: .random(in: 0...1),
                blue: .random(in: 0...1),
                alpha: 1.0)
    }
}

#if DEBUG

public extension BaldStudio where T: UIColor {
    var literial: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        this.getRed(&r, green: &g, blue: &b, alpha: &a)
        return "#colorLiteral(red: \(r), green: \(g), blue: \(b), alpha: \(a))"
    }

}

#endif
