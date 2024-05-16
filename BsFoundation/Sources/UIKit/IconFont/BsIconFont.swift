//
//  BsIconFont.swift
//  BsFoundation
//
//  Created by changrunze on 2023/6/8.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

// MARK: -  IconFont

public protocol BsIconFont: BsIconFontRepresentable, CaseIterable, RawRepresentable where RawValue == String {}

public extension BsIconFont {
    var unicode: String {
        rawValue
    }
}

// MARK: -  IconFont Representable

private class IconFontLocale {}

public protocol BsIconFontRepresentable {
    // ttf文件名
    var name: String { get }
    
    // 文件路径
    var path: String? { get }
    
    // icon原始值
    var unicode: String { get }
}

public extension BsIconFontRepresentable {
    var path: String? {
        if let path = Bundle.main.path(forResource: name, ofType: "ttf") {
            return path
        }
        
        if let path = Bundle(for: IconFontLocale.self).path(forResource: name, ofType: "ttf") {
            return path
        }
        
        return nil
    }
}

// MARK: -  Register

public extension UIFont {
    convenience init?(iconFont: BsIconFontRepresentable, size: CGFloat) {
        if UIFont.fontNames(forFamilyName: iconFont.name).isEmpty {
            let fileURL = URL(fileURLWithPath: iconFont.path ?? "")
            logger.info("尝试注册字体，path: \(fileURL)")
            UIFont.registerFont(with: fileURL)
        }
        self.init(name: iconFont.name, size: size)
    }
}

