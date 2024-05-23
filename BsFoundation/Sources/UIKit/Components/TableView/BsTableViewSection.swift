//
//  BsTableViewSection.swift
//  BsFoundation
//
//  Created by changrunze on 2023/6/7.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

// MARK: - Property

open class BsTableViewSection: NSObject {
    public typealias Parent = BsTableViewDataSource
    public typealias Child = BsTableViewNode

    open weak internal(set) var parent: Parent? = nil
    
    open var tableView: BsTableView? { parent?.parent }

    open var children: ContiguousArray<Child> = []
        
    deinit {
        logger.debug("\(self.classForCoder) -> deinit 🔥")
    }

    public override init() {
        super.init()
    }
    
    open func reload(with animation: UITableView.RowAnimation = .none) {
        guard let tableView = tableView, let index = index else { return }
        tableView.reloadSections([index], with: animation)
    }
    
    // MARK: - Node Actions
    
    open var count: Int {
        children.count
    }
    
    open var isEmpty: Bool {
        children.isEmpty
    }
    
    open var index: Int? {
        parent?.children.firstIndex(of: self)
    }
    
    open func append(_ child: Child) {
        guard !children.contains(child) else { return }
        child.removeFromParent()
        children.append(child)
        child.parent = self
    }
    
    open func append(children: [Child]) {
        children.forEach { append($0) }
    }
    
    open func insert(_ child: Child, at index: Int) {
        guard !children.contains(child) else { return }
        child.removeFromParent()
        children.insert(child, at: index)
        child.parent = self
    }
    
    open func replace(childAt index: Int, with child: Child) {
        if children.contains(child), let otherIndex = children.firstIndex(of: child) {
            children.swapAt(index, otherIndex)
        } else {
            child.removeFromParent()
            children[index] = child
            child.parent = self
        }
    }
    
    open func remove(at index: Int) {
        children[index].parent = nil
        children.remove(at: index)
    }
    
    open func remove(_ child: Child) {
        if let index = children.firstIndex(of: child) {
            remove(at: index)
        }
    }
    
    open func remove(children: [Child]) {
        children.forEach { remove($0) }
    }
    
    open func removeAll() {
        children.reversed().forEach { remove($0) }
    }
    
    open func removeFromParent() {
        parent?.remove(self)
    }
    
    open func child(at index: Int) -> Child {
        children[index]
    }
    
    open func contains(_ child: Child) -> Bool {
        children.contains { $0 == child }
    }
    
    open subscript(index: Int) -> Child {
        set {
            replace(childAt: index, with: newValue)
        }
        get {
            children[index]
        }
    }
    
    // MARK: - Header

    /// Header 自适应尺寸，设置 vertical 自适应高度
    open var preferredHeaderLayoutSizeFitting: LayoutSizeFitting = .none {
        didSet {
            if preferredHeaderLayoutSizeFitting == .none {
                estimatedHeaderHeight = headerHeight
            } else {
                estimatedHeaderHeight = 10 // whatever but nonzero
            }
        }
    }

    var estimatedHeaderHeight: CGFloat = 0

    open var headerHeight: CGFloat = 0 {
        didSet {
            estimatedHeaderHeight = headerHeight
        }
    }
    
    open var headerClass: UITableViewHeaderFooterView.Type = UITableViewHeaderFooterView.self
    
    open var headerNib: UINib?

    open var headerReuseIdentifier: String {
        "\(Self.self).\(headerClass).Header"
    }
    
    open var headerView: UITableViewHeaderFooterView? {
        guard let index = index,
              let tableView = tableView else {
            return nil
        }
        
        return tableView.headerView(forSection: index)
    }
    
    open func tableView(_ tableView: BsTableView,
                        viewForHeaderInSection section: Int) -> UIView? {
        tableView.registerHeaderIfNeeded(self)
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerReuseIdentifier)
        else { return nil }
        update(header: header, in: section)
        return header
    }
    
    open func update(header: UITableViewHeaderFooterView,
                     in section: Int) {}
    
    open func willDisplay(header view: UIView, in section: Int) {}
    
    open func didEndDisplaying(header view: UIView, in section: Int) {}
    
    // MARK: - Footer

    /// Footer 自适应尺寸，设置 vertical 自适应高度
    open var preferredFooterLayoutSizeFitting: LayoutSizeFitting = .none {
        didSet {
            if preferredFooterLayoutSizeFitting == .none {
                estimatedFooterHeight = footerHeight
            } else {
                estimatedFooterHeight = 10 // whatever but nonzero
            }
        }
    }

    var estimatedFooterHeight: CGFloat = 0

    open var footerHeight: CGFloat = 0 {
        didSet {
            estimatedFooterHeight = footerHeight
        }
    }
    
    open var footerClass: UITableViewHeaderFooterView.Type = UITableViewHeaderFooterView.self
    
    open var footerNib: UINib?

    open var footerReuseIdentifier: String {
        "\(Self.self).\(footerClass).Footer"
    }
    
    open var footerView: UITableViewHeaderFooterView? {
        guard let index = index,
              let tableView = tableView else {
            return nil
        }
        
        return tableView.footerView(forSection: index)
    }
    
    open func tableView(_ tableView: BsTableView,
                        viewForFooterInSection section: Int) -> UIView? {
        tableView.registerFooterIfNeeded(self)
        guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: footerReuseIdentifier) else {
            return nil
        }
        update(footer: footer, in: section)
        return footer
    }
    
    open func update(footer: UITableViewHeaderFooterView,
                     in section: Int) {}
    
    open func willDisplay(footer view: UIView, in section: Int) {}
    
    open func didEndDisplaying(footer view: UIView, in section: Int) {}
    
}

// MARK: - Auto Size Fitting

extension BsTableViewSection {
    /// 自适应Header尺寸
    func tableView(_ tableView: UITableView, preferredHeaderLayoutSizeFittingInSection section: Int) -> CGFloat {
        if preferredHeaderLayoutSizeFitting == .none { return headerHeight }
        return UITableView.automaticDimension
    }

    /// 自适应Footer尺寸
    func tableView(_ tableView: UITableView, preferredFooterLayoutSizeFittingInSection section: Int) -> CGFloat {
        if preferredFooterLayoutSizeFitting == .none { return footerHeight }
        return UITableView.automaticDimension
    }
}

// MARK: - Operator

public extension BsTableViewSection {
    static func += (left: BsTableViewSection, right: Child) {
        left.append(right)
    }
    
    static func -= (left: BsTableViewSection, right: Child) {
        left.remove(right)
    }
}
