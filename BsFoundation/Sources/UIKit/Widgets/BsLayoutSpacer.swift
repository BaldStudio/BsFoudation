//
//  BsLayoutSpacer.swift
//  BsFoundation
//
//  Created by 常润泽 on 2024/1/25.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

/**
 不参与渲染，只负责撑开布局或占位
 */
open class BsLayoutSpacer: BsUIView {
    private var contentSize: CGSize = .zero

    public convenience init(size: CGSize) {
        self.init(frame: .zero)
        contentSize = size
    }

    open override func commonInit() {
        super.commonInit()
        applyingFixed()
    }

    open override var intrinsicContentSize: CGSize {
        contentSize
    }

    public override class var layerClass: AnyClass {
        CATransformLayer.self
    }
}
