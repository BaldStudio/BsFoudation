//
//  BsSafeInsetsView.swift
//  BsFoundation
//
//  Created by changrunze on 2023/11/30.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

public extension BsSafeInsetsView {
    enum Edge {
        case bottom
        case top
    }
}

public final class BsSafeInsetsView: BsLayoutSpacer {
    public private(set) var edge: Edge = .bottom

    public required init(edge: Edge = .bottom) {
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
