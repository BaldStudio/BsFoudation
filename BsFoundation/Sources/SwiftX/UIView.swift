//
//  UIView.swift
//  BsSwiftX
//
//  Created by crzorz on 2021/7/16.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

// MARK: Shape

public extension BaldStudio where T: UIView {
    
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
