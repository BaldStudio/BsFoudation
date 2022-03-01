//
//  UIImage.swift
//  BsSwiftPlus
//
//  Created by crzorz on 2021/8/26.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import UIKit

public extension SwiftPlus where T: UIImage {

    func cropped(to rect: CGRect) -> UIImage {
        guard rect.size.width <= this.size.width,
              rect.size.height <= this.size.height else { return this }
        let scaledRect = rect.applying(CGAffineTransform(scaleX: this.scale, y: this.scale))
        guard let image = this.cgImage?.cropping(to: scaledRect) else { return this }
        return UIImage(cgImage: image,
                       scale: this.scale,
                       orientation: this.imageOrientation)
    }

}

public extension UIImage {
    
    @inlinable
    convenience init(color: UIColor) {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 1)

        defer {
            UIGraphicsEndImageContext()
        }

        color.setFill()
        UIRectFill(rect)

        guard let result = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            self.init()
            return
        }
        
        self.init(cgImage: result)
    }
    
}
