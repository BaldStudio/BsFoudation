//
//  BsTableViewProxy.swift
//  BsFoundation
//
//  Created by changrunze on 2023/6/7.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

// MARK: - Property

final class BsTableViewProxy: NSObject, UITableViewDelegate {
    private lazy var impl = BsTableViewProxyImpl(self)
    
    @NullResetable(default: BsTableViewDataSource())
    var dataSource: BsTableViewDataSource!
    
    weak var tableView: BsTableView! {
        didSet {
            dataSource.parent = tableView
        }
    }
    
    weak var target: UITableViewDelegate?
    
    deinit {
        logger.debug("\(self.classForCoder) -> deinit 🔥")
    }

    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        (target?.responds(to: aSelector) == true ? target : impl) ?? super.forwardingTarget(for: aSelector)
    }
    
    override func responds(to aSelector: Selector!) -> Bool {
        target?.responds(to: aSelector) == true || impl.responds(to: aSelector) == true || super.responds(to: aSelector)
    }
    
}

// MARK: - Delegate Impl

private final class BsTableViewProxyImpl: NSObject, UITableViewDelegate {
    weak var proxy: BsTableViewProxy!
    
    deinit {
        logger.debug("\(self.classForCoder) -> deinit 🔥")
    }
    
    convenience init(_ proxy: BsTableViewProxy) {
        self.init()
        self.proxy = proxy
    }
}

// MARK: - Cell

extension BsTableViewProxyImpl {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = proxy.dataSource[indexPath]
        if let heightCache = row.heightCache { return heightCache }
        var height = row.tableView(tableView, preferredLayoutSizeFixedAt: indexPath)
        height = row.tableView(tableView, preferredLayoutSizeFittingAt: indexPath)
        row.heightCache = height
        return height
    }
    
    func tableView(_ tableView: UITableView,
                   estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        proxy.dataSource[indexPath].estimatedHeight
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        proxy.dataSource[indexPath].tableView(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView,
                   didEndDisplaying cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        // 数据源发生变化，执行remove时，会先触发这里，需要处理数组越界问题
        // 此时外部 Item 对象不再触发该方法，如有特殊需要，可在其他类（如ViewController）实现该代理方法执行逻辑
        guard indexPath.section < proxy.dataSource.count else {
            return
        }
        let section = proxy.dataSource[indexPath.section]
        guard indexPath.row < section.count else {
            return
        }
        section[indexPath.row].tableView(tableView, didEndDisplaying: cell, forRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        proxy.dataSource[indexPath].tableView(tableView, didSelectRowAt: indexPath)
    }
}

// MARK: - Header

extension BsTableViewProxyImpl {
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        proxy.dataSource[section].tableView(tableView, preferredHeaderLayoutSizeFittingInSection: section)
    }
    
    func tableView(_ tableView: UITableView,
                   estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        proxy.dataSource[section].estimatedHeaderHeight
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        proxy.dataSource[section].tableView(proxy.tableView, viewForHeaderInSection: section)
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplayHeaderView view: UIView, forSection section: Int) {
        proxy.dataSource[section].willDisplay(header: view, in: section)
    }
    
    func tableView(_ tableView: UITableView,
                   didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        // 数据源发生变化，执行remove时，会先触发这里，需要处理数组越界问题
        // 此时外部 Item 对象不再触发该方法，如有特殊需要，可在其他类（如ViewController）实现该代理方法执行逻辑
        guard section < proxy.dataSource.count else {
            return
        }
        proxy.dataSource[section].didEndDisplaying(header: view, in: section)
    }
}

// MARK: - Footer

extension BsTableViewProxyImpl {
    func tableView(_ tableView: UITableView,
                   heightForFooterInSection section: Int) -> CGFloat {
        proxy.dataSource[section].tableView(tableView, preferredFooterLayoutSizeFittingInSection: section)
    }
    
    func tableView(_ tableView: UITableView,
                   estimatedHeightForFooterInSection section: Int) -> CGFloat {
        proxy.dataSource[section].estimatedFooterHeight
    }
    
    func tableView(_ tableView: UITableView,
                   viewForFooterInSection section: Int) -> UIView? {
        proxy.dataSource[section].tableView(proxy.tableView, viewForFooterInSection: section)
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplayFooterView view: UIView,
                   forSection section: Int) {
        proxy.dataSource[section].willDisplay(footer: view, in: section)
    }
    
    func tableView(_ tableView: UITableView,
                   didEndDisplayingFooterView view: UIView,
                   forSection section: Int) {
        // 数据源发生变化，执行remove时，会先触发这里，需要处理数组越界问题
        // 此时外部 Item 对象不再触发该方法，如有特殊需要，可在其他类（如ViewController）实现该代理方法执行逻辑
        guard section < proxy.dataSource.count else {
            return
        }
        proxy.dataSource[section].didEndDisplaying(footer: view, in: section)
    }
}

