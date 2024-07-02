//
//  UIImage+.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/16.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

import Accelerate

public extension UIImage {
    convenience init?(named name: String, in bundle: Bundle? = nil) {
        self.init(named: name, in: bundle, compatibleWith: nil)
    }
    
    convenience init(colored color: UIColor) {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        let image = UIGraphicsImageRenderer(bounds: rect).image {
            color.setFill()
            $0.fill(rect)
        }
        if let cgImage = image.cgImage {
            self.init(cgImage: cgImage)
        } else {
            logger.warn("make color to image failed")
            self.init()
        }
    }
}

public extension UIImage {
    func cropping(to rect: CGRect) -> UIImage {
        guard rect.size.width <= size.width,
              rect.size.height <= size.height else {
            return self
        }
        let scaledRect = rect.applying(CGAffineTransform(scaleX: scale, y: scale))
        guard let image = cgImage?.cropping(to: scaledRect) else {
            return self
        }
        return UIImage(cgImage: image,
                       scale: scale,
                       orientation: imageOrientation)
    }
}

//MARK: - Blur Effect

public extension UIImage {
    func applyLightEffect() -> UIImage? {
        applyBlur(withRadius: 30, saturation: 1.8, tintColor: UIColor(white: 1.0, alpha: 0.3))
    }
    
    func applyExtraLightEffect() -> UIImage? {
        applyBlur(withRadius: 20, saturation: 1.8, tintColor: UIColor(white: 0.97, alpha: 0.82))
    }
    
    func applyDarkEffect() -> UIImage? {
        applyBlur(withRadius: 20, saturation: 1.8, tintColor: UIColor(white: 0.11, alpha: 0.73))
    }
    
    func applyTintEffect(withColor tintColor: UIColor) -> UIImage? {
        let effectColorAlpha: CGFloat = 0.6
        var effectColor = tintColor
        
        let componentCount = tintColor.cgColor.numberOfComponents
        
        if componentCount == 2 {
            var b: CGFloat = 0
            if tintColor.getWhite(&b, alpha: nil) {
                effectColor = UIColor(white: b, alpha: effectColorAlpha)
            }
        } else {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            
            if tintColor.getRed(&red, green: &green, blue: &blue, alpha: nil) {
                effectColor = UIColor(red: red, green: green, blue: blue, alpha: effectColorAlpha)
            }
        }
        
        return applyBlur(withRadius: 10, saturation: -1.0, tintColor: effectColor)
    }
    
    func applyBlur(withRadius blurRadius: CGFloat,
                   saturation saturationDeltaFactor: CGFloat,
                   tintColor: UIColor?,
                   maskImage: UIImage? = nil) -> UIImage? {
        let size = self.size
        if (size.width < 1 || size.height < 1) {
            logger.error("*** error: invalid size: \(size.width) x \(size.height). Both dimensions must be >= 1: \(self)")
            return nil
        }
        
        guard let cgImage else {
            logger.error("*** error: image must be backed by a CGImage: \(self)")
            return nil
        }
        
        let __FLT_EPSILON__ = CGFloat.ulpOfOne
        let screenScale = UIScreen.main.scale
        let imageRect = CGRect(origin: .zero, size: size)
        var effectImage: UIImage = self
        
        let hasBlur = blurRadius > __FLT_EPSILON__
        let hasSaturationChange = abs(saturationDeltaFactor - 1.0) > __FLT_EPSILON__
        
        if hasBlur || hasSaturationChange {
            func createEffectBuffer(_ context: CGContext) -> vImage_Buffer {
                let data = context.data
                let width = vImagePixelCount(context.width)
                let height = vImagePixelCount(context.height)
                let rowBytes = context.bytesPerRow
                
                return vImage_Buffer(data: data, height: height, width: width, rowBytes: rowBytes)
            }
            
            UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
            guard let effectInContext = UIGraphicsGetCurrentContext() else { return  nil }
            
            effectInContext.scaleBy(x: 1.0, y: -1.0)
            effectInContext.translateBy(x: 0, y: -size.height)
            effectInContext.draw(cgImage, in: imageRect)
            
            var effectInBuffer = createEffectBuffer(effectInContext)
            
            UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
            
            guard let effectOutContext = UIGraphicsGetCurrentContext() else { return  nil }
            var effectOutBuffer = createEffectBuffer(effectOutContext)
            
            if hasBlur {
                let inputRadius = blurRadius * screenScale
                let d = floor(inputRadius * 3.0 * CGFloat(sqrt(2 * .pi) / 4 + 0.5))
                var radius = UInt32(d)
                if radius % 2 != 1 {
                    radius += 1
                }
                
                let imageEdgeExtendFlags = vImage_Flags(kvImageEdgeExtend)
                
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
                vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
            }
            
            var effectImageBuffersAreSwapped = false
            
            if hasSaturationChange {
                let s: CGFloat = saturationDeltaFactor
                let floatingPointSaturationMatrix: [CGFloat] = [
                    0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                    0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                    0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                    0,                    0,                    0,                    1
                ]
                
                let divisor: CGFloat = 256
                let matrixSize = floatingPointSaturationMatrix.count
                var saturationMatrix = [Int16](repeating: 0, count: matrixSize)
                
                for i: Int in 0 ..< matrixSize {
                    saturationMatrix[i] = Int16(round(floatingPointSaturationMatrix[i] * divisor))
                }
                
                if hasBlur {
                    vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                    effectImageBuffersAreSwapped = true
                }
                else {
                    vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                }
            }
            
            if !effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()!
            }
            
            UIGraphicsEndImageContext()
            
            if effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()!
            }
            
            UIGraphicsEndImageContext()
        }
        
        // Set up output context.
        UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
        
        guard let outputContext = UIGraphicsGetCurrentContext() else { return nil }
        
        outputContext.scaleBy(x: 1.0, y: -1.0)
        outputContext.translateBy(x: 0, y: -size.height)
        
        // Draw base image.
        outputContext.draw(cgImage, in: imageRect)
        
        // Draw effect image.
        if hasBlur {
            outputContext.saveGState()
            
            if let maskImage = maskImage {
                
                if let maskCGImage = maskImage.cgImage {
                    outputContext.clip(to: imageRect, mask: maskCGImage);
                }
                else {
                    logger.error("*** error: maskImage must be backed by a CGImage: \(String(describing: maskImage))")
                }
            }
            
            outputContext.draw(effectImage.cgImage!, in: imageRect)
            outputContext.restoreGState()
        }
        
        // Add in color tint.
        if let color = tintColor {
            outputContext.saveGState()
            outputContext.setFillColor(color.cgColor)
            outputContext.fill(imageRect)
            outputContext.restoreGState()
        }
        
        // Output image is ready.
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return outputImage
    }
}
