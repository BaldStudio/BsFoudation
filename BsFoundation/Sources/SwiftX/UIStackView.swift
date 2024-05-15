//
//  UIStackView.swift
//  BsFoundation
//
//  Created by changrunze on 2023/10/13.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

public extension SwiftX where T: UIStackView {
    func insertArrangedSubview(_ view: UIView, before siblingSubview: UIView) {
        guard let index = this.arrangedSubviews.firstIndex(of: siblingSubview) else { return }
        this.insertArrangedSubview(view, at: index)
    }
    
    func insertArrangedSubview(_ view: UIView, after siblingSubview: UIView) {
        guard let index = this.arrangedSubviews.firstIndex(of: siblingSubview) else { return }
        if index + 1 < this.arrangedSubviews.count {
            this.insertArrangedSubview(view, at: index + 1)
        } else {
            this.addArrangedSubview(view)
        }
    }
}
