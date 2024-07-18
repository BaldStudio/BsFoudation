//
//  BsDivideLine.swift
//  BsFoundation
//
//  Created by changrunze on 2023/9/20.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

public final class BsDivideLine: BsUIView {
    /// 分割线颜色，修改后，每次创建的线都会改变
    /// 如果仅改变当前的线，可以直接修改backgroundColor
    public static var defaultColor: UIColor = UIColor(0xD8D8D8)
    
    public override func onInit() {
        backgroundColor = BsDivideLine.defaultColor
    }
    
    public override var intrinsicContentSize: CGSize {
        [UIView.noIntrinsicMetric, Design.Height.line]
    }
}
