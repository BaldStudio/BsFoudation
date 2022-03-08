//
//  UIColor.swift
//  BsSwiftPlus
//
//  Created by crzorz on 2021/7/16.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import UIKit

public protocol ColorProvider {}

private protocol _ColorProvider: ColorProvider {
    var _color: UIColor { get }
}

public extension SwiftPlus where T: ColorProvider {
    var color: UIColor {
        if let val = self as? _ColorProvider {
            return val._color
        }
        return .clear
    }
}

// MARK: - Int

extension Int: _ColorProvider {
    fileprivate var _color: UIColor {
        var value = Int64(self)
        if self > 0x00FFFFFF {
            value = Swift.min(value, 0xFFFFFFFF)
            return UIColor.bs.color(red: (self & 0xFFFF0000) >> 16,
                                    green: (self & 0xFFFF00) >> 8,
                                    blue: self & 0xFF00,
                                    alpha: self & 0xFF)
        }
        return UIColor.bs.color(red: (self & 0xFF0000) >> 16,
                                green: (self & 0xFF00) >> 8,
                                blue: self & 0xFF)
    }
}

// MARK: - String

extension String: _ColorProvider {
    fileprivate var _color: UIColor {
        var str = trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        guard str.count > 5 else {
            return .clear
        }
        
        func slice(at idx: Int) -> String {
            String(str.suffix(str.count-idx))
        }
        
        func slice(from idx: Int, length: Int) -> String {
            let begin = str.index(str.startIndex, offsetBy: idx)
            let end = str.index(str.startIndex, offsetBy: idx+length)
            return String(str[begin..<end])
        }
        
        if str.hasPrefix("0X") {
            str = slice(at: 2)
        }
        else if str.hasPrefix("#") {
            str = slice(at: 1)
        }
        
        guard str.count > 5 else {
            return .clear
        }
        
        var alpha = "FF"
        if str.count > 7 {
            alpha = slice(from: 6, length: 2)
        }
        else if str.count > 6 {
            alpha = slice(from: 6, length: 1) + "F"
        }
        let a = Int(alpha, radix: 16) ?? 0
        let r = Int(slice(from: 0, length: 2), radix: 16) ?? 0
        let g = Int(slice(from: 2, length: 2), radix: 16) ?? 0
        let b = Int(slice(from: 4, length: 2), radix: 16) ?? 0
        
        return UIColor.bs.color(red: r,
                                green: g,
                                blue: b,
                                alpha: a)
        
    }
}

// MARK: - UIColor

extension UIColor: _ColorProvider {
    fileprivate var _color: UIColor {
        self
    }
}

public extension SwiftPlus where T: UIColor {
    
    static func dynamic(light: ColorProvider, dark: ColorProvider, alpha: CGFloat? = nil) -> UIColor {
        guard let light = light as? _ColorProvider,
              let dark = dark as? _ColorProvider
        else { return .clear }
        
        if #available(iOS 13.0, *) {
            return UIColor {
                let isLight = ($0.userInterfaceStyle == .light)
                if let alpha = alpha {
                    return isLight ? light._color.withAlphaComponent(alpha) : dark._color.withAlphaComponent(alpha)
                }
                return isLight ? light._color : dark._color
            }
        }
        
        if let alpha = alpha {
            return light._color.withAlphaComponent(alpha)
        }
        return light._color
    }

    static func color(red: Int, green: Int, blue: Int, alpha: Int = 255) -> UIColor {
        func filter(_ i: Int) -> CGFloat {
            var n = max(0, i)
            n = min(255, n)
            return CGFloat(n)
        }
        
        let r = filter(red)
        let g = filter(green)
        let b = filter(blue)
        let a = filter(alpha)

        return UIColor(red: r / 255.0,
                       green: g / 255.0,
                       blue: b / 255.0,
                       alpha: a / 255.0)
    }
    
    /// 0xFFFFFF
    static func hex(_ hex: Int) -> UIColor {
        hex._color
    }
    
    /// "0xFFFFFF"
    static func hex(_ hex: String) -> UIColor {
        hex._color
    }
    
    /// 随机色
    static var random: UIColor {
        var randomNum: Int {
            Int.random(in: 0...255)
        }
        
        return color(red: randomNum, green: randomNum, blue: randomNum)
    }
}
