//
//  UIView.swift
//  BsSwiftPlus
//
//  Created by crzorz on 2021/7/16.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import UIKit

// MARK: - Common

public extension SwiftPlus where T: UIView {
    /// 截图
    var snapshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(this.layer.frame.size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        this.layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }

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
        
}

// MARK: - Hierarchy

public extension SwiftPlus where T: UIView {
    func removeSubviews() {
        this.subviews.forEach { $0.removeFromSuperview() }
    }
    
    func subviews<T>(ofType _: T.Type) -> [T] {
        var views = [T]()
        for subview in this.subviews {
            if let view = subview as? T {
                views.append(view)
            }
            else if !subview.subviews.isEmpty {
                views.append(contentsOf: subview.bs.subviews(ofType: T.self))
            }
        }
        return views
    }
}

// MARK: - Layout

public extension SwiftPlus where T: UIView {
        
    func edgesEqualToSuperview(_ edges: UIEdgeInsets = .zero) {
        guard let superview = this.superview else { fatalError() }
        
        this.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            this.leftAnchor.constraint(equalTo: superview.leftAnchor,
                                       constant: edges.left),
            this.rightAnchor.constraint(equalTo: superview.rightAnchor,
                                        constant: edges.right),
            this.topAnchor.constraint(equalTo: superview.topAnchor,
                                      constant: edges.top),
            this.bottomAnchor.constraint(equalTo: superview.bottomAnchor,
                                         constant: edges.bottom),
        ])
    }
    
}

// MARK: - Responder

public extension SwiftPlus where T: UIView {
    var viewController: UIViewController? {
        var responder: UIResponder? = this
        while responder != nil {
            responder = responder!.next
            if let target = responder as? UIViewController {
                return target
            }
        }
        
        return BsWindow.rootViewController
    }
}

// MARK: - Gestures

public extension SwiftPlus where T: UIView {
    /// 添加tap手势
    func onTap(_ closure: @escaping Closure.primary) {
        this.bs_onTap = closure
        let tap = UITapGestureRecognizer(target: this,
                                         action: #selector(T.bs_onTapEvent(_:)))
        this.addGestureRecognizer(tap)
    }

}

private extension UIView {
    struct AssociateKeys {
        static var onTapEvent = "onTapEventKey"
    }
        
    var bs_onTap: Closure.primary? {
        set {
            objc_setAssociatedObject(self,
                                     &AssociateKeys.onTapEvent,
                                     newValue,
                                     .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            objc_getAssociatedObject(self, &AssociateKeys.onTapEvent) as? Closure.primary
        }
    }
    
    @objc
    func bs_onTapEvent(_ sender: UITapGestureRecognizer) {
        bs_onTap?()
    }
}
