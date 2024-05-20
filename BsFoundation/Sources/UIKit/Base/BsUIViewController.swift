//
//  BsUIViewController.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/16.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

open class BsUIViewController: UIViewController {
    deinit {
        logger.debug("\(classForCoder) -> deinit 🔥")
    }
    
    public override init(nibName nibNameOrNil: String?,
                         bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    open func commonInit() {

    }
    
    open override func loadView() {
        view = BsUIView()
    }
    
    open override var shouldAutorotate: Bool {
        children.first?.shouldAutorotate ?? super.shouldAutorotate
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        children.first?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
    }
    
    open override var childForStatusBarStyle: UIViewController? {
        children.first
    }
    
    open override var childForStatusBarHidden: UIViewController? {
        children.first
    }
    
    open override var childForHomeIndicatorAutoHidden: UIViewController? {
        children.first
    }
    
    open override var childForScreenEdgesDeferringSystemGestures: UIViewController? {
        children.first
    }
}
