//
//  BsLoaderButton.swift
//  BsFoundation
//
//  Created by changrunze on 2023/8/17.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

public protocol IndicatorProtocol {
    func startAnimating()
    func stopAnimating()
}

public typealias IndicatorRepresentable = UIView & IndicatorProtocol

extension UIActivityIndicatorView: IndicatorProtocol {}

open class BsLoaderButton: BsUIButton {
    open var spinner: IndicatorRepresentable = UIActivityIndicatorView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.hidesWhenStopped = true
        $0.color = .white
        if #available(iOS 13.0, *) {
            $0.style = .medium
        } else {
            $0.style = .white
        }
    }
    
    open var isLoading = false {
        didSet {
            updateView()
        }
    }
            
    open override func commonInit() {
        super.commonInit()
        addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    open func customSpinner(_ view: IndicatorRepresentable) {
        spinner.removeFromSuperview()
        spinner = view
        addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    open func updateView() {
        if isLoading {
            isEnabled = false
            spinner.startAnimating()
            titleLabel?.alpha = 0
            imageView?.alpha = 0
        } else {
            spinner.stopAnimating()
            titleLabel?.alpha = 1
            imageView?.alpha = 1
            isEnabled = true
        }
    }
}
