//
//  UIView.swift
//  BsSwiftPlus
//
//  Created by crzorz on 2021/7/16.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import UIKit

public extension SwiftPlus where T: UIView {
    /// 获取nib
    static func nib(_ name: String? = nil) -> UINib {
        let nibName = name ?? "\(this)"
        let bundle = Bundle(for: this)
        return UINib(nibName: nibName, bundle: bundle)
    }
    
    /// 从xib加载视图
    static func loadFromNib(name nibNameOrNil: String? = nil,
                            bundle nibBundleOrNil: Bundle? = nil) -> T? {
        let nibName = nibNameOrNil ?? "\(this)"
        let bundle = nibBundleOrNil ?? Bundle(for: this)
        let objects = bundle.loadNibNamed(nibName, owner: nil, options: nil)
        guard let view = objects?.first as? T else { return nil }
        return view
    }
    
    /// 添加边框
    func border(_ w: CGFloat = 0.5, _ c: UIColor = .white) {
        this.layer.borderWidth = w
        this.layer.borderColor = c.cgColor
    }
    
    var snapshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(this.layer.frame.size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        this.layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }

}

// MARK: - Layout

public extension SwiftPlus where T: UIView {
        
    func edgesEqualToSuperview(_ edges: UIEdgeInsets = .zero) {
        this.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            this.leftAnchor.constraint(equalTo: this.superview!.leftAnchor,
                                       constant: edges.left),
            this.rightAnchor.constraint(equalTo: this.superview!.rightAnchor,
                                        constant: edges.right),
            this.topAnchor.constraint(equalTo: this.superview!.topAnchor,
                                      constant: edges.top),
            this.bottomAnchor.constraint(equalTo: this.superview!.bottomAnchor,
                                         constant: edges.bottom),
        ])
    }

}

// MARK: - Gestures

public extension SwiftPlus where T: UIView {
    /// 添加tap手势
    func onTap(_ closure: @escaping Closure.primary) {
        this._onTap = closure
        let tap = UITapGestureRecognizer(target: this,
                                         action: #selector(UIView._handleTapEvent(sender:)))
        this.addGestureRecognizer(tap)
    }

}

private extension UIView {
    private var _onTapEventKey: UnsafePointer<CChar> {
        "com.bald-studio.view.onTapEventKey".withCString { $0 }
    }
    
    var _onTap: Closure.primary? {
        set {
            objc_setAssociatedObject(self,
                                     _onTapEventKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            objc_getAssociatedObject(self, _onTapEventKey) as? Closure.primary
        }
    }
    
    @objc func _handleTapEvent(sender: UITapGestureRecognizer) {
        _onTap?()
    }
}
