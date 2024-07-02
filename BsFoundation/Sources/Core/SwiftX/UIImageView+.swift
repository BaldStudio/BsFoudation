//
//  UIImageView+.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/16.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

public extension UIImageView {
    convenience init?(image name: String, in bundle: Bundle? = nil) {
        self.init(image: UIImage(named: name, in: bundle, with: nil))
    }
}
