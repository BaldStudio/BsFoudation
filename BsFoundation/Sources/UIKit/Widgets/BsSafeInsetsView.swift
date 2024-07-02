//
//  BsSafeInsetsView.swift
//  BsFoundation
//
//  Created by changrunze on 2023/11/30.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

public final class BsSafeInsetsView: BsLayoutMargin {
    public private(set) var edge: SafeArea.Edge = .bottom

    public required init(edge: SafeArea.Edge = .bottom) {
        super.init(frame: .zero)
        self.edge = edge
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override var intrinsicContentSize: CGSize {
        if edge == .bottom {
            return [Screen.width, SafeArea.bottom]
        }
        return [Screen.width, SafeArea.top]
    }
}
