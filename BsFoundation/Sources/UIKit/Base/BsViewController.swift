//
//  BsViewController.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/22.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

/// 业务基类
open class BsViewController: BsUIViewController, UIGestureRecognizerDelegate {
    /// 导航栏的返回按钮
    ///  - 在 viewDidLoad 中初始化
    ///  - 当值为 nil 时隐藏
    ///  - 可以通过指定 customView 设置自定义视图
    open var backItem: UIBarButtonItem? {
        didSet {
            if let backItem = backItem {
                navigationItem.leftBarButtonItem = backItem
            } else {
                navigationItem.leftBarButtonItem = nil
            }
        }
    }
        
    // MARK: - Override Methods
    
    open override func loadView() {
        view = BsView()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButtonIfNeeded()
    }
            
    @objc
    open func onPressBackButton(_ sender: UIButton) {
        if let navigationController = navigationController,
           navigationController.children.count > 1 {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
}

@objc
extension UIViewController {
    open var shouldAutoHideNavigationBar: Bool {
        false
    }
}

private extension BsViewController {
    func setupBackButtonIfNeeded() {
        guard let navigationController = navigationController,
            navigationController.children.count > 1 else {
            return
        }
        navigationItem.hidesBackButton = true
        backItem = NavigationBackItem(self, #selector(onPressBackButton(_:)))
    }
}

// MARK: - Back Button

private extension UIImage {
    static let backArrow = UIImage(systemName: "chevron.left",
                                   withConfiguration: SymbolConfiguration(pointSize: 24))
}

private class NavigationBackItem: UIBarButtonItem {
    convenience init(_ target: BsViewController, _ action: Selector) {
        let button = UIButton(type: .custom).then {
            $0.contentHorizontalAlignment = .left
            $0.frame = CGRect(origin: .zero, size: [44, 44])
            $0.setImage(.backArrow, for: .normal)
            $0.addTarget(target, action: action, for: .touchUpInside)
        }
        self.init(customView: button)
        if let nav = target.navigationController,
           let gesture = nav.interactivePopGestureRecognizer {
            gesture.delegate = target
        }
    }
}
