//
//  UIColor.swift
//  BsSwiftX
//
//  Created by crzorz on 2021/7/16.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import UIKit

extension UIColor {
        
    public convenience init(_ hex: Int, alpha: CGFloat = 1.0) {
        let hex = min(0xFFFFFF, max(0, hex))
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255
        let g = CGFloat((hex & 0xFF00) >> 8) / 255
        let b = CGFloat((hex & 0xFF)) / 255
        let alpha = min(1, max(0, alpha))
        self.init(red: r,
                  green: g,
                  blue: b,
                  alpha: alpha)
    }
    
    public convenience init(_ hexString: String, alpha: CGFloat = 1.0) {
        var hex = hexString.uppercased()
        
        if hex.hasPrefix("0X") {
            hex = hex.bs.slice(at: 2)
        }
        else if hex.hasPrefix("#") {
            hex = hex.bs.slice(at: 1)
        }

        let alpha = min(1, max(0, alpha))
        guard hex.count == 6 else {
            self.init(0, alpha: alpha)
            return
        }
        
        self.init(Int(hex, radix: 16) ?? 0, alpha: alpha)
    }
    
    /// rgb color, value limit 0 - 255
    public convenience init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, alpha: CGFloat = 1.0) {
        let r = min(255, max(0, alpha))
        let g = min(255, max(0, alpha))
        let b = min(255, max(0, alpha))
        let alpha = min(1, max(0, alpha))
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}

public extension SwiftX where T: UIColor {
    
    var toImage: UIImage {
        UIImage.bs.make(with: this)
    }
    
    
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

public extension SwiftX where T: UIColor {
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
