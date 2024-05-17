//
//  UIStackView+.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/16.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

public extension UIStackView {
    func insertArrangedSubview(_ view: UIView, before siblingSubview: UIView) {
        guard let index = arrangedSubviews.firstIndex(of: siblingSubview) else { return }
        insertArrangedSubview(view, at: index)
    }
    
    func insertArrangedSubview(_ view: UIView, after siblingSubview: UIView) {
        guard let index = arrangedSubviews.firstIndex(of: siblingSubview) else { return }
        if index + 1 < arrangedSubviews.count {
            insertArrangedSubview(view, at: index + 1)
        } else {
            addArrangedSubview(view)
        }
    }
}

