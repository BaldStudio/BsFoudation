//
//  UIDefines.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/17.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

// MARK: -  屏幕宽高

public enum Screen {
    public static let scale: CGFloat = UIScreen.main.scale
    public static let bounds: CGRect = UIScreen.main.bounds
    public static let size: CGSize = bounds.size
    public static let width: CGFloat = size.width
    public static let height: CGFloat = size.height
}

// MARK: -  安全边距

public enum SafeArea {
    public enum Edge {
        case bottom
        case top
    }

    public static let insets = BsApp.mainWindow?.safeAreaInsets ?? .zero
    public static let top = insets.top
    public static let bottom = insets.bottom
}

// MARK: -  常用布局尺寸

public enum Design {}

public extension Design {
    enum Height {
        public static let statusBar: CGFloat = 20
        public static let navigationBar: CGFloat = 44 + SafeArea.top
        public static let tabBar: CGFloat = 49 + SafeArea.bottom
        public static let line: CGFloat = 1.0 / Screen.scale
    }
}

/// 自动布局的计算方式
public enum LayoutMode {
    /// 系统算法，如 TableView 中指定 cell 的高度为 automaticDimension
    case auto
    /// 通过代码实现，这个过程调用方可以感知到
    case manual
}

/// 自动布局的作用方向
public enum LayoutSizeFitting {
    case none
    case vertical   /// 垂直方向自适应  as 定宽算高
    case horizontal /// 水平方向自适应  as 定高算宽
}

/// 布局尺寸的固定拉伸方向
public enum LayoutSizeFixed {
    case none
    case vertical   /// 垂直方向撑满父视图
    case horizontal /// 水平方向撑满父视图
}
