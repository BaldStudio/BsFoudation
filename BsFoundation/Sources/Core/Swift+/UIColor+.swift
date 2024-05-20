//
//  UIColor+.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/16.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

public extension UIColor {
    var asImage: UIImage {
        UIImage(colored: self)
    }
    
    /// 随机色
    @inlinable
    static var random: UIColor {
        UIColor(red: .random(in: 0...1),
                green: .random(in: 0...1),
                blue: .random(in: 0...1),
                alpha: 1.0)
    }
}

public extension UIColor {
    convenience init(_ hex: Int, alpha: CGFloat = 1.0) {
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
    
    convenience init(_ hexString: String, alpha: CGFloat = 1.0) {
        var hex = hexString.uppercased()
        
        if hex.hasPrefix("0X") {
            hex = hex.slice(at: 2)
        }
        else if hex.hasPrefix("#") {
            hex = hex.slice(at: 1)
        }

        let alpha = min(1, max(0, alpha))
        guard hex.count == 6 else {
            self.init(0, alpha: alpha)
            return
        }
        
        self.init(Int(hex, radix: 16) ?? 0, alpha: alpha)
    }
    
    convenience init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, alpha: CGFloat = 1.0) {
        let r = min(255, max(0, alpha))
        let g = min(255, max(0, alpha))
        let b = min(255, max(0, alpha))
        let alpha = min(1, max(0, alpha))
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}

#if DEBUG

public extension UIColor {
    var literial: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return "#colorLiteral(red: \(r), green: \(g), blue: \(b), alpha: \(a))"
    }
}

#endif
