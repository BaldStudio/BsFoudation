//
//  UIColor.swift
//  BsSwiftPlus
//
//  Created by crzorz on 2021/7/16.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import UIKit

extension UIColor {
        
    public convenience init(_ hex: Int, alpha: CGFloat = 1.0) {
        let hex = min(0xFFFFFF, max(0, hex))
        self.init(red: (hex & 0xFF0000) >> 16,
                  green: (hex & 0xFF00) >> 8,
                  blue: (hex & 0xFF),
                  alpha: alpha)
    }
    
    public convenience init(_ hexString: String, alpha: CGFloat = 1.0) {
        var hex = hexString.bs.trimmed.uppercased()
        
        if hex.hasPrefix("0X") {
            hex = hex.bs.slice(at: 2)
        }
        else if hex.hasPrefix("#") {
            hex = hex.bs.slice(at: 1)
        }

        guard hex.count == 6 else {
            self.init(0, alpha: alpha)
            return
        }
        
        self.init(Int(hex, radix: 16) ?? 0, alpha: alpha)
    }
    
    public convenience init(red: Int,
                     green: Int,
                     blue: Int,
                     alpha: CGFloat = 1.0) {
        
        let r = CGFloat(min(255, max(0, red)))
        let g = CGFloat(min(255, max(0, green)))
        let b = CGFloat(min(255, max(0, blue)))
        self.init(red: r / 255,
                  green: g / 255,
                  blue: b / 255,
                  alpha: alpha)

    }

}

public extension SwiftPlus where T: UIColor {
    
    var toImage: UIImage? {
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
        UIColor(red: .random(in: 0...255),
                green: .random(in: 0...255),
                blue: .random(in: 0...255))
    }
}
