//
//  BsTableView.swift
//  BsFoundation
//
//  Created by crzorz on 2021/7/8.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import UIKit

open class BsTableView: UITableView {
    private var proxy = BsTableViewProxy()
        
    public private(set) var rootNode = DataSource()

    public override init(frame: CGRect, style: Style) {
        super.init(frame: frame, style: style)
        
        backgroundColor = .white
        dataSource = rootNode
        delegate = proxy

        proxy._dataSource = rootNode
        proxy._tableView = self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    open override var dataSource: UITableViewDataSource? {
        get {
            rootNode
        }
        set {
            if let ds = newValue as? DataSource {
                super.dataSource = ds
                rootNode = ds
                ds.parent = self
            }
            else {
                fatalError("the dataSource MUST be TableView.DataSource type")
            }
        }
    }
    
    open override var delegate: UITableViewDelegate? {
        set {            
            if newValue == nil {
                super.delegate = nil
                return
            }
            
            if !(newValue is Proxy) {
                proxy.target = newValue
            }
            super.delegate = proxy
        }
        get {
            super.delegate
        }
    }

    open override func register(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String) {
        super.register(cellClass, forCellReuseIdentifier: identifier)
        rootNode.registryMap[identifier] = cellClass
    }
    
    open override func register(_ nib: UINib?, forCellReuseIdentifier identifier: String) {
        super.register(nib, forCellReuseIdentifier: identifier)
        rootNode.registryMap[identifier] = nib
    }
    
    open override func register(_ nib: UINib?, forHeaderFooterViewReuseIdentifier identifier: String) {
        super.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
        rootNode.registryMap[identifier] = nib
    }
    
    open override func register(_ aClass: AnyClass?, forHeaderFooterViewReuseIdentifier identifier: String) {
        super.register(aClass, forHeaderFooterViewReuseIdentifier: identifier)
        rootNode.registryMap[identifier] = aClass
    }
    
}

private class BsTableViewProxy: Proxy, UITableViewDelegate {
    weak var _dataSource: BsTableView.DataSource!
    weak var _tableView: BsTableView!

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0
        let row = _dataSource[indexPath]
        if row.autofitCellHeight {
            height = row.tableView(_tableView, autofitCellHeightAt: indexPath)
        }
        else {
            height = row.cellHeight;
        }

        if height < 0 {
            height = 0
        }

        return height
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        _dataSource[indexPath].tableView(tableView, willDisplay: cell, forRowAt: indexPath)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _dataSource[indexPath].tableView(tableView, didSelectRowAt: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        _dataSource[section].tableView(tableView, heightForHeaderInSection: section)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sec: BsTableView.Section = _dataSource[section]
        let reuseID = sec.headerReuseIdentifier
        
        if !_dataSource.isRegistered(reuseID) {
            if let nibNode = sec as? NibLoadable {
                tableView.register(nibNode.nib, forHeaderFooterViewReuseIdentifier: reuseID)
            }
            else {
                tableView.register(sec.headerViewClass, forHeaderFooterViewReuseIdentifier: reuseID)
            }
        }

        return sec.tableView(tableView, viewForHeaderInSection: section)
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        _dataSource[section].tableView(tableView,
                                       willDisplayHeaderView: view,
                                       forSection: section)
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        _dataSource[section].tableView(tableView, heightForFooterInSection: section)
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sec = _dataSource[section]
        let reuseID = sec.footerReuseIdentifier
        
        if !_dataSource.isRegistered(reuseID) {
            if let nibNode = sec as? NibLoadable {
                tableView.register(nibNode.nib, forHeaderFooterViewReuseIdentifier: reuseID)
            }
            else {
                tableView.register(sec.footerViewClass, forHeaderFooterViewReuseIdentifier: reuseID)
            }
        }
        return _dataSource[section].tableView(tableView, viewForFooterInSection: section)
    }

    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        _dataSource[section].tableView(tableView,
                                       willDisplayFooterView: view,
                                       forSection: section)
    }

}
