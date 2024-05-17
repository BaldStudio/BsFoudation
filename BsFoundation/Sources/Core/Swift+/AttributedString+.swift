//
//  AttributedString+.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/17.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

public extension NSMutableAttributedString {
    func set(attributes: [NSAttributedString.Key: Any], substring: String? = nil) {
        if let substring = substring, let range = string.range(of: substring) {
            set(attributes: attributes, within: NSRange(range, in: string))
        } else {
            set(attributes: attributes, within: NSMakeRange(0, string.count))
        }
    }
    
    func set(attributes: [NSAttributedString.Key: Any], within range: NSRange) {
        if range.location == NSNotFound { return }
        setAttributes(attributes, range: range)
    }
    
    // MARK: - Text Color

    func set(textColor: UIColor, substring: String? = nil) {
        if let substring = substring, let range = string.range(of: substring) {
            set(textColor: textColor, within: NSRange(range, in: string))
        } else {
            set(textColor: textColor, within: NSMakeRange(0, string.count))
        }
    }
    
    func set(textColor: UIColor, within range: NSRange) {
        if range.location == NSNotFound { return }
        addAttributes([.foregroundColor: textColor], range: range)
    }
    
    // MARK: - Font
    
    func set(font: UIFont, substring: String? = nil) {
        if let substring = substring, let range = string.range(of: substring) {
            set(font: font, within: NSRange(range, in: string))
        } else {
            set(font: font, within: NSMakeRange(0, string.count))
        }
    }
    
    func set(font: UIFont, within range: NSRange) {
        if range.location == NSNotFound { return }
        addAttributes([.font: font], range: range)
    }
    
    // MARK: - Alignment
    
    func set(alignment: NSTextAlignment, substring: String? = nil) {
        if let substring = substring, let range = string.range(of: substring) {
            set(alignment: alignment, within: NSRange(range, in: string))
        } else {
            set(alignment: alignment, within: NSMakeRange(0, string.count))
        }
    }
    
    func set(alignment: NSTextAlignment, within range: NSRange) {
        if range.location == NSNotFound { return }
        let style = NSMutableParagraphStyle().then { $0.alignment = alignment }
        addAttributes([.paragraphStyle: style], range: range)
    }
}

