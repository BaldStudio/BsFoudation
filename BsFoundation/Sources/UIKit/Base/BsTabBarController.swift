//
//  BsTabBarController.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/22.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

// MARK: - Delegate

public protocol BsTabBarControllerDelegate: AnyObject {
    func tabBarController(_ tabBarController: BsTabBarController,
                          shouldSelect viewController: UIViewController) -> Bool
    func tabBarController(_ tabBarController: BsTabBarController,
                          didSelect viewController: UIViewController)
}

extension BsTabBarControllerDelegate {
    func tabBarController(_ tabBarController: BsTabBarController,
                          shouldSelect viewController: UIViewController) -> Bool { true }
    
    func tabBarController(_ tabBarController: BsTabBarController,
                          didSelect viewController: UIViewController) {}
}

// MARK: - Controller

open class BsTabBarController: BsViewController {
    open lazy var tabBar = BsTabBar().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview($0)
        NSLayoutConstraint.activate([
            $0.leftAnchor.constraint(equalTo: view.leftAnchor),
            $0.rightAnchor.constraint(equalTo: view.rightAnchor),
            $0.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    open var viewControllers: [UIViewController] = [] {
        willSet {
            viewControllers.forEach { $0.bs_tabBarController = nil }
            newValue.forEach { $0.bs_tabBarController = self }
        }
        didSet {
            reloadTabBar()
        }
    }
    
    open var selectedIndex: Int {
        get {
            tabBar.selectedIndex
        }
        set {
            tabBar.selectedIndex = newValue
        }
    }
    
    open var selectedViewController: UIViewController? {
        set {
            removeSelectedViewController()
            guard let newValue = newValue ?? viewControllers.first else {
                return
            }
            setSelectedViewController(newValue)
            delegate?.tabBarController(self, didSelect: newValue)
        }
        get {
            viewControllers.isEmpty ? nil : viewControllers[selectedIndex]
        }
    }
    
    open weak var delegate: BsTabBarControllerDelegate?
    
    open override var title: String? {
        set {
            super.title = newValue
            parent?.title = newValue
        }
        get {
            super.title ?? tabBarItem.title
        }
    }
    
    open func reloadTabBar() {
        tabBar.reloadItems()
    }

    open override var shouldAutorotate: Bool {
        selectedViewController?.shouldAutorotate ?? super.shouldAutorotate
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        selectedViewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
    }
    
    open override var childForStatusBarStyle: UIViewController? {
        selectedViewController
    }
    
    open override var childForStatusBarHidden: UIViewController? {
        selectedViewController
    }
    
    open override var childForHomeIndicatorAutoHidden: UIViewController? {
        selectedViewController
    }
    
    open override var childForScreenEdgesDeferringSystemGestures: UIViewController? {
        selectedViewController
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        selectedViewController?.preferredInterfaceOrientationForPresentation ?? super.preferredInterfaceOrientationForPresentation
    }
    
    open override var prefersHomeIndicatorAutoHidden: Bool {
        selectedViewController?.prefersHomeIndicatorAutoHidden ?? super.prefersHomeIndicatorAutoHidden
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        selectedViewController?.preferredStatusBarStyle ?? super.preferredStatusBarStyle
    }
}

private extension BsTabBarController {
    func setSelectedViewController(_ vc: UIViewController) {
        addChild(vc)
        view.addSubview(vc.view)
        vc.didMove(toParent: self)
        title = vc.title
        view.bringSubviewToFront(tabBar)
    }
    
    func removeSelectedViewController() {
        guard let selectedViewController else { return }
        selectedViewController.willMove(toParent: nil)
        selectedViewController.view.removeFromSuperview()
        selectedViewController.removeFromParent()
    }
}

// MARK: - Bar

open class BsTabBar: BsView {
    private let contentView = UIStackView().then {
        $0.spacing = 24
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .top
    }
    private let backdropView: UIVisualEffectView = .blur()
    
    private var viewControllers: [UIViewController] = []
    
    open var items: [BsTabBarItem] = [] {
        didSet {
            reloadItems()
        }
    }
    
    open var selectedItem: BsTabBarItem? {
        set {
            if newValue.isNil {
                selectedIndex = 0
                return
            }
            guard let newValue, let index = items.firstIndex(of: newValue) else { return }
            selectedIndex = index
        }
        get {
            items.safe(objectAt: selectedIndex)
        }
    }
    
    open var selectedIndex: Int = 0 {
        willSet {
            let newValue = max(0, newValue)
            if selectedIndex == newValue { return }
            guard newValue < items.count else { return }
            items[selectedIndex].isSelected = false
            items[newValue].isSelected = true
        }
    }
    
    open override func commonInit() {
        addSubview(backdropView)
        backdropView.edgesEqualToSuperview()
        
        addSubview(contentView)
        contentView.edgesEqualToSuperview(with: .init(horizontal: 48))
    }
    
    open override var intrinsicContentSize: CGSize {
        [UIView.noIntrinsicMetric, 49 + SafeArea.bottom]
    }
    
    func reloadItems() {
        contentView.removeSubviews()
        items.forEach {
            contentView.addArrangedSubview($0)
            $0.removeTarget(self, gesture: nil)
            $0.addTarget(self, action: BsTabBar.onSelectTabBarItem)
        }
        selectedIndex = 0
    }
    
    private func onSelectTabBarItem(_ sender: UITapGestureRecognizer) {
        guard let item = sender.view as? BsTabBarItem else { return }
        selectedItem = item
    }
}

// MARK: - Item

open class BsTabBarItem: BsView {
    private let contentView = UIStackView().then {
        $0.spacing = 4
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .center
    }
    private let imageView = UIImageView().then {
        $0.contentMode = .center
    }
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 10)
        $0.textAlignment = .center
    }

    open var title: String?
    
    open var image: UIImage?
    open var selectedImage: UIImage?
        
    open var titleColor: UIColor = .systemBlue
    open var selectedTitleColor: UIColor = .systemBlue
    
    open var isSelected: Bool = false {
        didSet {
            imageView.isHighlighted = isSelected
            titleLabel.isHighlighted = isSelected
            self.setNeedsDisplay()
        }
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public required init(viewController: UIViewController) {
        super.init(frame: .zero)
        
        guard let tabBarItem = viewController.tabBarItem else { return }
        
        image = tabBarItem.image
        imageView.image = image
        
        selectedImage = tabBarItem.selectedImage ?? image
        imageView.highlightedImage = selectedImage
                
        title = tabBarItem.title ?? viewController.title
        titleLabel.text = title
        
        let colorKey = NSAttributedString.Key.foregroundColor
        if let attributes = tabBarItem.titleTextAttributes(for: .normal) {
            titleColor = attributes[colorKey] as? UIColor ?? .systemBlue
        }
        titleLabel.textColor = titleColor
        
        if let attributes = tabBarItem.titleTextAttributes(for: .selected) {
            selectedTitleColor = attributes[colorKey] as? UIColor ?? .systemBlue
        }
        titleLabel.highlightedTextColor = selectedTitleColor;
    
        contentView.addArrangedSubview(imageView)
        contentView.addArrangedSubview(titleLabel)
        addSubview(contentView)
        contentView.edgesEqualToSuperview()
    }
    
    open override var intrinsicContentSize: CGSize {
        [76, 48]
    }
}

// MARK: -  Extensions

private enum RuntimeKey {
    static var tabBarController = 0
    static var tabBarItem = 0
}

private extension UIViewController {
    var bs_tabBarController: BsTabBarController? {
        get {
            value(forAssociated: &RuntimeKey.tabBarController)
        }
        set {
            set(associate: newValue, for: &RuntimeKey.tabBarController)
        }
    }
    
    var bs_tabBarItem: BsTabBarItem {
        get {
            value(forAssociated: &RuntimeKey.tabBarItem) ?? BsTabBarItem(viewController: self)
        }
        set {
            set(associate: newValue, for: &RuntimeKey.tabBarItem)
        }
    }

}

public extension BaldStudio where T: UIViewController {
    var tabBarController: BsTabBarController? { this.bs_tabBarController }
    var tabBarItem: BsTabBarItem { this.bs_tabBarItem }
}
