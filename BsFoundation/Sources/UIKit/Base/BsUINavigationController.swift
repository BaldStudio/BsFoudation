//
//  BsUINavigationController.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/16.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

open class BsUINavigationController: UINavigationController {
    deinit {
        logger.debug("\(classForCoder) -> deinit 🔥")
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
        commonInit()
    }
    
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        commonInit()
    }
    
    open func commonInit() {
        
    }
    
    open override var shouldAutorotate: Bool {
        topViewController?.shouldAutorotate ?? super.shouldAutorotate
    }

    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        topViewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
    }

    open override var childForStatusBarStyle: UIViewController? {
        topViewController ?? super.childForStatusBarStyle
    }

    open override var childForStatusBarHidden: UIViewController? {
        topViewController ?? super.childForStatusBarHidden
    }

    open override var childForHomeIndicatorAutoHidden: UIViewController? {
        topViewController ?? super.childForHomeIndicatorAutoHidden
    }

    open override var childForScreenEdgesDeferringSystemGestures: UIViewController? {
        topViewController ?? super.childForScreenEdgesDeferringSystemGestures
    }
}
