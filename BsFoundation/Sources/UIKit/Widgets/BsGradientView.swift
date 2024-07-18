//
//  BsGradientView.swift
//  BsFoundation
//
//  Created by changrunze on 2023/6/16.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

open class BsGradientView: BsUIView {
    public enum Direction {
        case horizontal
        case vertical
        case custom(CGPoint, CGPoint)
        
        fileprivate var pointValue: (CGPoint, CGPoint) {
            switch self {
            case .horizontal:
                return ([0, 0.5], [1, 0.5])
            case .vertical:
                return ([0.5, 0], [0.5, 1])
            case .custom(let start, let end):
                return (start, end)
            }
        }
    }

    private var effectLayer: CAGradientLayer {
        layer as! CAGradientLayer
    }
    
    open var colors: [UIColor] = [] {
        didSet {
            setNeedsLayout()
        }
    }
    
    open var locations: [CGFloat] = [0, 1]  {
        didSet {
            setNeedsLayout()
        }
    }
    
    open var startPoint: CGPoint = [0, 0.5] {
        didSet {
            setNeedsLayout()
        }
    }
    
    open var endPoint: CGPoint = [1, 0.5] {
        didSet {
            setNeedsLayout()
        }
    }

    /// 渐变方向
    open var direction: Direction = .horizontal {
        didSet {
            let points = direction.pointValue
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

