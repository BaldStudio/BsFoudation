//
//  UIDefines.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/17.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

// MARK: -  屏幕宽高

public enum Screen {
    static let scale: CGFloat = UIScreen.main.scale
    static let bounds: CGRect = UIScreen.main.bounds
    static let size: CGSize = bounds.size
    static let width: CGFloat = size.width
    static let height: CGFloat = size.height
}

// MARK: -  安全边距

public enum SafeArea {
    public static let insets = BsAppMainWindow?.safeAreaInsets ?? .zero
    public static let top = insets.top
    public static let bottom = insets.bottom
}

// MARK: -  常用布局尺寸

public enum Design {}

public extension Design {
    enum Height {
        static let navigationBar: CGFloat = 44 + SafeArea.top
        static let tabBar: CGFloat = 49 + SafeArea.bottom
        static let line: CGFloat = 1.0 / Screen.scale
    }
}
