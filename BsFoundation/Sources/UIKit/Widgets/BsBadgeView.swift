//
//  BsBadgeView.swift
//  BsFoundation
//
//  Created by changrunze on 2023/10/27.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

open class BsBadgeView: BsBoxLabel {
    /// 红点样式的高度
    @objc
    public static let preferredHeight: CGFloat = 8
    
    /// 本文样式的高度
    @objc
    public static let preferredTextHeight: CGFloat = 10
    
    /// 默认为 -1 时，视图呈现圆角为高度的一半
    open var cornerRadius: CGFloat = -1 {
        didSet {
            setNeedsLayout()
        }
    }
    
    open override func commonInit() {
        layer.masksToBounds = true
        textAlignment = NSTextAlignment.center
        textInsets = UIEdgeInsets(horizontal: 6, vertical: 2)
        backgroundColor = UIColor(0xF65231)
        textColor = .white
        font = .systemFont(ofSize: 8)
    }
        
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        if cornerRadius < 0 {
            layer.cornerRadius = bounds.height * 0.5
        } else {
            layer.cornerRadius = cornerRadius
        }
    }
}
