//
//  BsNavigationController.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/22.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

open class BsNavigationController: BsUINavigationController, UINavigationControllerDelegate {
    open override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        modalPresentationStyle = .fullScreen
        view.backgroundColor = .white
    }
    
    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.isNotEmpty {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(_: viewController, animated: animated)
    }

    open override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        if viewControllers.count > 1, let vc = viewControllers.last {
            vc.hidesBottomBarWhenPushed = true
        }
        super.setViewControllers(viewControllers, animated: animated)
    }
    
    // MARK: - Navigation Controller Delegate

    open func navigationController(_ navigationController: UINavigationController,
                                     willShow viewController: UIViewController,
                                     animated: Bool) {
        let shouldHiddenNavigationBar = viewController.shouldAutoHideNavigationBar
        navigationController.setNavigationBarHidden(shouldHiddenNavigationBar, animated: true)
    }
}

// MARK: - Interactive Pop Manager

public protocol BsNavigationControllerInteraction: UIViewController {
    func enableInteractivePopGestureRecognizer(_ isEnabled: Bool)
}

public extension BsNavigationControllerInteraction {
    func enableInteractivePopGestureRecognizer(_ isEnabled: Bool = true) {
        guard let navigationController = self.navigationController,
            navigationController.viewControllers.count > 1,
            let gesture = navigationController.interactivePopGestureRecognizer else {
            return
        }
        gesture.isEnabled = isEnabled
    }
}
