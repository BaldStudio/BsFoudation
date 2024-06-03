//
//  NSAttributedString++.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/17.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

// MARK: -  Attributes

// from https://github.sheincorp.cn/Nirma/Attributed/blob/main/README.md

extension NSAttributedString {
    public struct Attributes {
        public let value: [NSAttributedString.Key: Any]
        
        public init() {
            value = [:]
        }

        public init(_ maker: (Attributes) -> Attributes) {
            self = maker(Attributes())
        }

        init(value: [NSAttributedString.Key: Any]) {
            self.value = value
        }
    }
}

private extension [NSAttributedString.Key: Any] {
    var paragraphStyle: NSMutableParagraphStyle {
        (self[Key.paragraphStyle] ?? NSMutableParagraphStyle.default.mutableCopy()) as! NSMutableParagraphStyle
    }
}

public extension NSAttributedString.Attributes {
    func font(_ font: UIFont) -> NSAttributedString.Attributes {
        self + NSAttributedString.Attributes(value: [NSAttributedString.Key.font: font])
    }

    func kerning(_ kerning: Double) -> NSAttributedString.Attributes {
        self + NSAttributedString.Attributes(value: [NSAttributedString.Key.kern: kerning.asNSNumber])
    }

    func strikeThroughStyle(_ strikeThroughStyle: NSUnderlineStyle) -> NSAttributedString.Attributes {
        self + NSAttributedString.Attributes(value: [
            NSAttributedString.Key.strikethroughStyle: strikeThroughStyle.rawValue,
            NSAttributedString.Key.baselineOffset: (1.5).asNSNumber
        ])
    }

    func underlineStyle(_ underlineStyle: NSUnderlineStyle) -> NSAttributedString.Attributes {
        self + NSAttributedString.Attributes(value: [NSAttributedString.Key.underlineStyle: underlineStyle.rawValue])
    }

    func strokeColor(_ strokeColor: UIColor) -> NSAttributedString.Attributes {
        self + NSAttributedString.Attributes(value: [NSAttributedString.Key.strokeColor: strokeColor])
    }

    func strokeWidth(_ strokewidth: Double) -> NSAttributedString.Attributes {
        self + NSAttributedString.Attributes(value: [NSAttributedString.Key.strokeWidth: strokewidth.asNSNumber])
    }

    func foreground(color: UIColor) -> NSAttributedString.Attributes {
        self + NSAttributedString.Attributes(value: [NSAttributedString.Key.foregroundColor: color])
    }

    func background(color: UIColor) -> NSAttributedString.Attributes {
        self + NSAttributedString.Attributes(value: [NSAttributedString.Key.backgroundColor: color])
    }

    func paragraphStyle(_ paragraphStyle: NSParagraphStyle) -> NSAttributedString.Attributes {
        self + NSAttributedString.Attributes(value: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }

    func shadow(_ shadow: NSShadow) -> NSAttributedString.Attributes {
        self + NSAttributedString.Attributes(value: [NSAttributedString.Key.shadow: shadow])
    }

    func obliqueness(_ value: CGFloat) -> NSAttributedString.Attributes {
        self + NSAttributedString.Attributes(value: [NSAttributedString.Key.obliqueness: value])
    }

    func link(_ link: String) -> NSAttributedString.Attributes {
        self + NSAttributedString.Attributes(value: [NSAttributedString.Key.link: link])
    }

    func baselineOffset(_ offset: NSNumber) -> NSAttributedString.Attributes {
        self + NSAttributedString.Attributes(value: [NSAttributedString.Key.baselineOffset: offset])
    }
    
    // MARK: - NSParagraphStyle
    
    func lineSpacing(_ lineSpacing: CGFloat) -> NSAttributedString.Attributes {
        let paragraphStyle = value.paragraphStyle
        paragraphStyle.lineSpacing = lineSpacing
        return self + NSAttributedString.Attributes(value: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }

    func paragraphSpacing(_ paragraphSpacing: CGFloat) -> NSAttributedString.Attributes {
        let paragraphStyle = value.paragraphStyle
        paragraphStyle.paragraphSpacing =  paragraphSpacing
        return self + NSAttributedString.Attributes(value: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }

    func alignment(_ alignment: NSTextAlignment) -> NSAttributedString.Attributes {
        let paragraphStyle = value.paragraphStyle
        paragraphStyle.alignment = alignment
        return self + NSAttributedString.Attributes(value: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }

    func firstLineHeadIndent(_ firstLineHeadIndent: CGFloat) -> NSAttributedString.Attributes {
        let paragraphStyle = value.paragraphStyle
        paragraphStyle.firstLineHeadIndent = firstLineHeadIndent
        return self + NSAttributedString.Attributes(value: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }

    func headIndent(_ headIndent: CGFloat) -> NSAttributedString.Attributes {
        let paragraphStyle = value.paragraphStyle
        paragraphStyle.headIndent = headIndent
        return self + NSAttributedString.Attributes(value: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }

    func tailIndent(_ tailIndent: CGFloat) -> NSAttributedString.Attributes {
        let paragraphStyle = value.paragraphStyle
        paragraphStyle.tailIndent = tailIndent
        return self + NSAttributedString.Attributes(value: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }

    func lineBreakMode(_ lineBreakMode: NSLineBreakMode) -> NSAttributedString.Attributes {
        let paragraphStyle = value.paragraphStyle
        paragraphStyle.lineBreakMode = lineBreakMode
        return self + NSAttributedString.Attributes(value: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }

    func minimumLineHeight(_ minimumLineHeight: CGFloat) -> NSAttributedString.Attributes {
        let paragraphStyle = value.paragraphStyle
        paragraphStyle.minimumLineHeight = minimumLineHeight
        return self + NSAttributedString.Attributes(value: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }

    func maximumLineHeight(_ maximumLineHeight: CGFloat) -> NSAttributedString.Attributes {
        let paragraphStyle = value.paragraphStyle
        paragraphStyle.maximumLineHeight = maximumLineHeight
        return self + NSAttributedString.Attributes(value: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }

    func uniformLineHeight(_ uniformLineHeight: CGFloat) -> NSAttributedString.Attributes {
        maximumLineHeight(uniformLineHeight).minimumLineHeight(uniformLineHeight)
    }

    func baseWritingDirection(_ baseWritingDirection: NSWritingDirection) -> NSAttributedString.Attributes {
        let paragraphStyle = value.paragraphStyle
        paragraphStyle.baseWritingDirection = baseWritingDirection
        return self + NSAttributedString.Attributes(value: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }

    func lineHeightMultiple(_ lineHeightMultiple: CGFloat) -> NSAttributedString.Attributes {
        let paragraphStyle = value.paragraphStyle
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        return self + NSAttributedString.Attributes(value: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }

    func paragraphSpacingBefore(_ paragraphSpacingBefore: CGFloat) -> NSAttributedString.Attributes {
        let paragraphStyle = value.paragraphStyle
        paragraphStyle.paragraphSpacingBefore = paragraphSpacingBefore
        return self + NSAttributedString.Attributes(value: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }

    func hyphenationFactor(_ hyphenationFactor: Float) -> NSAttributedString.Attributes {
        let paragraphStyle = value.paragraphStyle
        paragraphStyle.hyphenationFactor = hyphenationFactor
        return self + NSAttributedString.Attributes(value: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }
}

// MARK: -  Operators

public func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
    let result = NSMutableAttributedString()
    result.append(lhs)
    result.append(rhs)
    return NSAttributedString(attributedString: result)
}

public func + (lhs: NSParagraphStyle, rhs: NSParagraphStyle) -> NSParagraphStyle {
    let defaultParagraph = NSParagraphStyle.default
    let combinedAttributes: NSMutableParagraphStyle = lhs.toMutableCopy()
    
    if rhs.lineSpacing != defaultParagraph.lineSpacing {
        combinedAttributes.lineSpacing = rhs.lineSpacing
    }
    
    if rhs.paragraphSpacing != defaultParagraph.paragraphSpacing {
        combinedAttributes.paragraphSpacing = rhs.paragraphSpacing
    }
    
    if rhs.alignment != defaultParagraph.alignment {
        combinedAttributes.alignment = rhs.alignment
    }
    
    if rhs.firstLineHeadIndent != defaultParagraph.firstLineHeadIndent {
        combinedAttributes.firstLineHeadIndent = rhs.firstLineHeadIndent
    }
    
    if rhs.headIndent != defaultParagraph.headIndent {
        combinedAttributes.headIndent = rhs.headIndent
    }
    
    if rhs.tailIndent != defaultParagraph.tailIndent {
        combinedAttributes.tailIndent = rhs.tailIndent
    }
    
    if rhs.lineBreakMode != defaultParagraph.lineBreakMode {
        combinedAttributes.lineBreakMode = rhs.lineBreakMode
    }
    
    if rhs.minimumLineHeight != defaultParagraph.minimumLineHeight {
        combinedAttributes.minimumLineHeight = rhs.minimumLineHeight
    }
    
    if rhs.maximumLineHeight != defaultParagraph.maximumLineHeight {
        combinedAttributes.maximumLineHeight = rhs.maximumLineHeight
    }
    
    if rhs.baseWritingDirection != defaultParagraph.baseWritingDirection {
        combinedAttributes.baseWritingDirection = rhs.baseWritingDirection
    }
    
    if rhs.lineHeightMultiple != defaultParagraph.lineHeightMultiple {
        combinedAttributes.lineHeightMultiple = rhs.lineHeightMultiple
    }
    
    if rhs.paragraphSpacingBefore != defaultParagraph.paragraphSpacingBefore {
        combinedAttributes.paragraphSpacingBefore = rhs.paragraphSpacingBefore
    }
    
    if rhs.hyphenationFactor != defaultParagraph.hyphenationFactor {
        combinedAttributes.hyphenationFactor = rhs.hyphenationFactor
    }
    
    if rhs.tabStops != defaultParagraph.tabStops {
        combinedAttributes.tabStops = rhs.tabStops
    }
    
    if rhs.defaultTabInterval != defaultParagraph.defaultTabInterval {
        combinedAttributes.defaultTabInterval = rhs.defaultTabInterval
    }
    
    if rhs.allowsDefaultTighteningForTruncation != defaultParagraph.allowsDefaultTighteningForTruncation {
        combinedAttributes.allowsDefaultTighteningForTruncation = rhs.allowsDefaultTighteningForTruncation
    }
    
    return combinedAttributes
}

public func + (lhs: NSAttributedString.Attributes,
               rhs: NSAttributedString.Attributes) -> NSAttributedString.Attributes {
    var combined = lhs.value
    for (key, value) in rhs.value {
        combined[key] = value
    }

    let combinedParagraphStyle: NSParagraphStyle?
    let lhsParagraphStyle = lhs.value[NSAttributedString.Key.paragraphStyle] as? NSParagraphStyle
    let rhsParagraphStyle = rhs.value[NSAttributedString.Key.paragraphStyle] as? NSParagraphStyle

    if let lhsParagraphStyle = lhsParagraphStyle, let rhsParagraphStyle = rhsParagraphStyle {
        combinedParagraphStyle = lhsParagraphStyle + rhsParagraphStyle
    } else {
        combinedParagraphStyle = lhsParagraphStyle ?? rhsParagraphStyle
    }
    if let paragraphStyle = combinedParagraphStyle {
        combined[NSAttributedString.Key.paragraphStyle] = paragraphStyle
    }
    return NSAttributedString.Attributes(value: combined)
}

// MARK: -  NSMutableAttributedString

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

// MARK: -  String

public extension String {
    func makeAttributedString(_ block: (NSAttributedString.Attributes) -> NSAttributedString.Attributes) -> NSAttributedString {
        let attributes = block(NSAttributedString.Attributes())
        return NSAttributedString(string: self, attributes: attributes.value)
    }
    
    var asHTMLAttributedString: NSAttributedString {
        let empty = NSAttributedString()
        guard let data = data(using: .utf8) else { return empty }
        let options: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            .documentType: NSAttributedString.DocumentType.html,
        ]
        guard let result = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return empty
        }
        return result
    }
}
