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
        
}

// MARK: - Hierarchy

public extension SwiftPlus where T: UIView {
    @inlinable
    func removeSubviews() {
        this.subviews.forEach { $0.removeFromSuperview() }
    }
    
    func subviews<T>(ofKind: T.Type) -> [T] {
        var views: [T] = []
        for subview in this.subviews {
            if let view = subview as? T {
                views.append(view)
            }
            else if !subview.subviews.isEmpty {
                views.append(contentsOf: subview.bs.subviews(ofKind: T.self))
            }
        }
        return views
    }
}

// MARK: - Layout

public extension SwiftPlus where T: UIView {
    
    func edgesEqualTo(_ v: UIView, with insets: UIEdgeInsets = .zero) {
        
        this.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            this.leftAnchor.constraint(equalTo: v.leftAnchor,
                                       constant: insets.left),
            this.rightAnchor.constraint(equalTo: v.rightAnchor,
                                        constant: insets.right),
            this.topAnchor.constraint(equalTo: v.topAnchor,
                                      constant: insets.top),
            this.bottomAnchor.constraint(equalTo: v.bottomAnchor,
                                         constant: insets.bottom),
        ])
    }
    
    func edgesEqualToSuperview(with insets: UIEdgeInsets = .zero) {
        guard let superview = this.superview else { fatalError() }
        edgesEqualTo(superview, with: insets)
    }
    
    func removeAllConstraints() {
        this.removeConstraints(this.constraints)
    }
}

// MARK: - Responder

public extension SwiftPlus where T: UIView {
    var viewController: UIViewController? {
        nearest(ofKind: UIViewController.self) ?? BsAppMainWindow.rootViewController
    }
}

// MARK: - Gestures

public extension SwiftPlus where T: UIView {
    /// 添加tap手势
    func onTap(_ closure: @escaping Action.primary) {
        this.bs_onTap = closure
        let tap = UITapGestureRecognizer(target: this,
                                         action: #selector(T.bs_onTapEvent(_:)))
        this.addGestureRecognizer(tap)
    }

}

private extension UIView {
    struct AssociatedKeys {
        static var onTapEvent = 0
    }
        
    var bs_onTap: Action.primary? {
        set {
            objc_setAssociatedObject(self,
                                     &AssociatedKeys.onTapEvent,
                                     newValue,
                                     .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            objc_getAssociatedObject(self, &AssociatedKeys.onTapEvent) as? Action.primary
        }
    }
    
    @objc
    func bs_onTapEvent(_ sender: UITapGestureRecognizer) {
        bs_onTap?()
    }
}

// MARK: Shape

public extension SwiftPlus where T: UIView {
    
    /// 添加边框
    @inlinable
    func border(_ w: CGFloat = 0.5, _ c: UIColor = .white) {
        this.layer.borderWidth = w
        this.layer.borderColor = c.cgColor
    }

    func drawLines(forEdge edges: UIRectEdge,
                   offset: CGFloat = 0,
                   color: UIColor = .separator) -> [UIView] {
        var lines: [UIView] = []
        let offset = max(offset, 0)
        
        func addLine() -> UIView {
            let line = UIView()
            line.isUserInteractionEnabled = false
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = color
            this.addSubview(line)
            return line
        }
        
        if edges.contains(.top) {
            let line = addLine()
            lines.append(line)
            NSLayoutConstraint.activate([
                line.leadingAnchor.constraint(equalTo: this.leadingAnchor, constant: offset),
                line.trailingAnchor.constraint(equalTo: this.trailingAnchor, constant: -offset),
                line.topAnchor.constraint(equalTo: this.topAnchor),
                line.heightAnchor.constraint(equalToConstant: 0.5)
            ])
        }
        
        if edges.contains(.bottom) {
            let line = addLine()
            lines.append(line)
            NSLayoutConstraint.activate([
                line.leadingAnchor.constraint(equalTo: this.leadingAnchor, constant: offset),
                line.trailingAnchor.constraint(equalTo: this.trailingAnchor, constant: -offset),
                line.bottomAnchor.constraint(equalTo: this.bottomAnchor),
                line.heightAnchor.constraint(equalToConstant: 0.5)
            ])
        }

        if edges.contains(.left) {
            let line = addLine()
            lines.append(line)
            NSLayoutConstraint.activate([
                line.leadingAnchor.constraint(equalTo: this.leadingAnchor),
                line.topAnchor.constraint(equalTo: this.topAnchor, constant: offset),
                line.bottomAnchor.constraint(equalTo: this.bottomAnchor, constant: -offset),
                line.widthAnchor.constraint(equalToConstant: 0.5)
            ])
        }

        if edges.contains(.right) {
            let line = addLine()
            lines.append(line)
            NSLayoutConstraint.activate([
                line.trailingAnchor.constraint(equalTo: this.trailingAnchor),
                line.topAnchor.constraint(equalTo: this.topAnchor, constant: offset),
                line.bottomAnchor.constraint(equalTo: this.bottomAnchor, constant: -offset),
                line.widthAnchor.constraint(equalToConstant: 0.5)
            ])
        }
        
        return lines
    }
    
}
