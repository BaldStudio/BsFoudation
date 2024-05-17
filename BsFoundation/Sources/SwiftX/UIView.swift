//
//  UIView.swift
//  BsSwiftX
//
//  Created by crzorz on 2021/7/16.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

private struct RuntimeKey {
    static var singleTap = 0
    static var gestures = 0
}

// MARK: - Gestures

public extension SwiftX where T: UIView {
    @discardableResult
    func addGestureAction<Target: AnyObject, Gesture: UIGestureRecognizer>(_ target: Target,
                                                                      action: @escaping Action<Target, Gesture>) -> Gesture {
        let gesture = Gesture(target: this, action: #selector(UIView.bs_onGestureEvent(_:)))
        this.addGestureRecognizer(gesture)
        this.gestures.append(UIView.GestureAction(gesture: gesture) { [weak target] gesture in
            guard let target, let gesture = gesture as? Gesture else { return }
            action(target)(gesture)
        })
        return gesture
    }
    
    func removeGestureAction(_ gesture: UIGestureRecognizer) {
        this.gestures.removeAll { $0.gesture == gesture }
        this.removeGestureRecognizer(gesture)
    }
    
    // MARK: - single tap
    
    func onSingleTap(_ closure: @escaping BlockT<UITapGestureRecognizer>) {
        this.singleTap = closure
        addGestureAction(this, action: UIView._onSingleTap)
    }
    
}

private extension UIView {
    
    struct GestureAction {
        let gesture: UIGestureRecognizer
        let action: (UIGestureRecognizer) -> Void
    }
    
    var gestures: [GestureAction] {
        get {
            var value: [GestureAction]? = value(forAssociated: &RuntimeKey.gestures)
            if value.isNil {
                value = []
                set(associate: value, for: &RuntimeKey.gestures)
            }
            return value!
            
        }
        set {
            set(associate: newValue, for: &RuntimeKey.gestures)
        }
    }
    
    @objc
    func bs_onGestureEvent(_ sender: UIGestureRecognizer) {
        for gesture in gestures where gesture.gesture == sender {
            gesture.action(sender)
        }
    }
    
    func _onSingleTap(_ sender: UITapGestureRecognizer) {
        singleTap?(sender)
    }
    
    var singleTap: BlockT<UITapGestureRecognizer>? {
        get {
            value(forAssociated: &RuntimeKey.singleTap)
        }
        set {
            set(associate: newValue, for: &RuntimeKey.singleTap)
        }
    }
}

// MARK: Shape

public extension SwiftX where T: UIView {
    
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
