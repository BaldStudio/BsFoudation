//
//  UIImageView.swift
//  BsFoundation
//
//  Created by changrunze on 2023/9/18.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

public extension UIImageView {
    convenience init?(imageNamed name: String, in bundle: Bundle? = nil) {
        self.init(image: UIImage(named: name, in: bundle))
    }
}
