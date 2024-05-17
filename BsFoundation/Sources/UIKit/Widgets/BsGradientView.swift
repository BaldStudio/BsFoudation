//
//  BsGradientView.swift
//  BsFoundation
//
//  Created by changrunze on 2023/6/16.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

@IBDesignable
open class BsGradientView: BsUIView {
    public enum Direction {
        case horizontal
        case vertical
        case custom(CGPoint, CGPoint)
        
        fileprivate func convertToPoints() -> (CGPoint, CGPoint) {
            switch self {
            case .horizontal:
                return (
                    [0, 0.5],
                    [1, 0.5]
                )
            case .vertical:
                return (
                    [0.5, 0],
                    [0.5, 1]
                )
            case .custom(let start, let end):
                return (start, end)
            }
        }
    }

    public var effectLayer: CAGradientLayer {
        layer as! CAGradientLayer
    }
    
    @IBInspectable
    open var colors: [UIColor] = [] {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    open var locations: [CGFloat] = [0, 1]  {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    open var startPoint: CGPoint = [0, 0.5] {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    open var endPoint: CGPoint = [1, 0.5] {
        didSet {
            setNeedsLayout()
        }
    }

    open var direction: Direction = .horizontal {
        didSet {
            let points = direction.convertToPoints()
            startPoint = points.0
            endPoint = points.1
        }
    }

    //MARK: - override
    
    public override class var layerClass: AnyClass {
        CAGradientLayer.self
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        effectLayer.startPoint = startPoint
        effectLayer.endPoint = endPoint
        effectLayer.locations = locations.map({ NSNumber(value: $0) })
        effectLayer.colors = colors.map({ $0.cgColor })
    }
}

