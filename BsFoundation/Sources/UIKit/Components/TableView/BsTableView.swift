//
//  BsTableView.swift
//  BsFoundation
//
//  Created by changrunze on 2023/6/7.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

// MARK: - Property

open class BsTableView: UITableView {
    fileprivate let proxy = BsTableViewProxy()
    
    open private(set) var registryMap: [String: AnyObject] = [:]
    
    deinit {
        logger.debug("\(classForCoder) -> deinit 🔥")
    }
    
    public override init(frame: CGRect, style: Style) {
        super.init(frame: frame, style: style)
        onInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        onInit()
    }
    
    public convenience init(delegate: UITableViewDelegate?) {
        if #available(iOS 13.0, *) {
            self.init(frame: .zero, style: .insetGrouped)
        } else {
            self.init(frame: .zero, style: .grouped)
        }
        self.delegate = delegate
    }
    
    open func onInit() {
        proxy.tableView = self
        delegate = proxy
        dataSource = proxy.dataSource
    }

    // MARK: - Override
    
    open override var dataSource: UITableViewDataSource? {
        set {
            if let dataSource = newValue as? BsTableViewDataSource {
                super.dataSource = dataSource
                proxy.dataSource = dataSource
            } else {
                super.dataSource = newValue
            }
        }
        get {
            proxy.dataSource
        }
    }
    
    open override var delegate: UITableViewDelegate? {
        set {
            guard let newValue else {
                proxy.target = nil
                return
            }
            if !(newValue is BsTableViewProxy) {
                proxy.target = newValue
            }
            super.delegate = proxy
        }
        get {
            super.delegate
        }
    }
    
    // MARK: - Register
    
    open override func register(_ cellClass: AnyClass?,
                                forCellReuseIdentifier identifier: String) {
        super.register(cellClass, forCellReuseIdentifier: identifier)
        registryMap[identifier] = cellClass
    }
    
    open override func register(_ nib: UINib?,
                                forCellReuseIdentifier identifier: String) {
        super.register(nib, forCellReuseIdentifier: identifier)
        registryMap[identifier] = nib
    }
    
    open override func register(_ nib: UINib?,
                                forHeaderFooterViewReuseIdentifier identifier: String) {
        super.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
        registryMap[identifier] = nib
    }
    
    open override func register(_ aClass: AnyClass?,
                                forHeaderFooterViewReuseIdentifier identifier: String) {
        super.register(aClass, forHeaderFooterViewReuseIdentifier: identifier)
        registryMap[identifier] = aClass
    }
    
    // MARK: - Additions
    
    open func append(section: BsTableViewSection) {
        proxy.dataSource.append(section)
    }

    open func insert(_ section: BsTableViewSection, at index: Int) {
        proxy.dataSource.insert(section, at: index)
    }

    open func remove(section: BsTableViewSection) {
        proxy.dataSource.remove(section)
    }

    open func removeAll() {
        proxy.dataSource.removeAll()
    }
    
    open func setDataSource(_ newValue: BsTableViewDataSource?) {
        dataSource = newValue
    }
}

// MARK: - Registry

extension BsTableView {
    final func registerCellIfNeeded(_ row: BsTableViewNode) {
        let id = row.reuseIdentifier
        if registryMap.contains(where: { $0.key == id }) {
            return
        }
        
        if let nib = row.nib {
            register(nib, forCellReuseIdentifier: id)
        }
        else {
            register(row.cellClass, forCellReuseIdentifier: id)
        }
    }
    
    final func registerHeaderIfNeeded(_ section: BsTableViewSection) {
        let id = section.headerReuseIdentifier
        if registryMap.contains(where: { $0.key == id }) {
            return
        }
        
        if let nib = section.headerNib {
            register(nib, forHeaderFooterViewReuseIdentifier: id)
        }
        else {
            register(section.headerClass, forHeaderFooterViewReuseIdentifier: id)
        }
    }
    
    final func registerFooterIfNeeded(_ section: BsTableViewSection) {
        let id = section.footerReuseIdentifier
        if registryMap.contains(where: { $0.key == id }) {
            return
        }
        
        if let nib = section.footerNib {
            register(nib, forHeaderFooterViewReuseIdentifier: id)
        } else {
            register(section.footerClass, forHeaderFooterViewReuseIdentifier: id)
        }
    }
}


// MARK: - Extensions

public extension BaldStudio where Hair: BsTableView {
    var dataSource: BsTableViewDataSource { this.proxy.dataSource }
}
