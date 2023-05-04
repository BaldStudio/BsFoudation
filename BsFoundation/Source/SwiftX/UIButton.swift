//
//  UIButton.swift
//  BsFoundation
//
//  Created by changrunze on 2023/9/18.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

public extension SwiftX where T: UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State = .normal) {
        this.setBackgroundImage(color.bs.toImage, for: state)
    }
}
