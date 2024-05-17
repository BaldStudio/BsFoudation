//
//  UIView+.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/16.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

public extension UIView {
    /// 截图
    var snapshot: UIImage? {
        UIGraphicsImageRenderer(bounds: bounds).image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
    }
    
    /// 获取nib
    static func nib(_ name: String? = nil) -> UINib {
        let nibName = name ?? "\(self)"
        let bundle = Bundle(for: self)
        return UINib(nibName: nibName, bundle: bundle)
    }
    
    /// 从xib加载视图
    static func load<T: UIView>(from nibNameOrNil: String? = nil,
                     bundle nibBundleOrNil: Bundle? = nil) -> T? {
        let nibName = nibNameOrNil ?? "\(self)"
        let bundle = nibBundleOrNil ?? Bundle(for: self)
        let objects = bundle.loadNibNamed(nibName, owner: nil, options: nil)
        return objects?.first as? T
    }
}

// MARK: - Hierarchy

public extension UIView {
    @inlinable
    func removeSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
    
    func subviews<Element>(ofKind: Element.Type) -> [Element] {
        var views: [Element] = []
        for subview in subviews {
            if let view = subview as? Element {
                views.append(view)
            }
            else if !subview.subviews.isEmpty {
                views.append(contentsOf: subview.subviews(ofKind: Element.self))
            }
        }
        return views
    }
}

// MARK: - Layout

public extension UIView {
    func edgesEqual(to v: UIView, with insets: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftAnchor.constraint(equalTo: v.leftAnchor,
                                  constant: insets.left),
            rightAnchor.constraint(equalTo: v.rightAnchor,
                                   constant: -insets.right),
            topAnchor.constraint(equalTo: v.topAnchor,
                                 constant: insets.top),
            bottomAnchor.constraint(equalTo: v.bottomAnchor,
                                    constant: -insets.bottom),
        ])
    }
    
    @inlinable
    func edgesEqualToSuperview(with insets: UIEdgeInsets = .zero) {
        guard let superview else { fatalError() }
        edgesEqual(to: superview, with: insets)
    }
    
    func removeAllConstraints() {
        removeConstraints(constraints)
    }
    
    @inlinable
    var safeTopAnchor: NSLayoutYAxisAnchor {
        safeAreaLayoutGuide.topAnchor
    }
    
    @inlinable
    var safeLeftAnchor: NSLayoutXAxisAnchor {
        safeAreaLayoutGuide.leftAnchor
    }
    
    @inlinable
    var safeRightAnchor: NSLayoutXAxisAnchor {
        safeAreaLayoutGuide.rightAnchor
    }
    
    @inlinable
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        safeAreaLayoutGuide.bottomAnchor
    }
}

// MARK: - Responder

public extension UIView {
    var viewController: UIViewController? {
        nearest(ofKind: UIViewController.self) ?? BsApp.mainWindow?.rootViewController
    }
}

// MARK: - Gestures

