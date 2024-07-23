//
//  BsCollectionView.swift
//  BsFoundation
//
//  Created by changrunze on 2023/6/30.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

// MARK: - Property

open class BsCollectionView: UICollectionView {
    fileprivate let proxy = BsCollectionViewProxy()
    
    open private(set) var registryMap: [String: AnyObject] = [:]

    deinit {
        logger.debug("\(self.classForCoder) -> deinit 🔥")
    }
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        onInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        onInit()
    }
    
    public convenience init(delegate: UICollectionViewDelegate?) {
        self.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        self.delegate = delegate
    }

    public convenience init(with layout: UICollectionViewLayout) {
        self.init(frame: .zero, collectionViewLayout: layout)
        self.delegate = delegate
    }
    
    open func onInit() {
        proxy.collectionView = self
        delegate = proxy
        dataSource = proxy.dataSource
    }
    
    // MARK: - Override

    open override var dataSource: UICollectionViewDataSource? {
        set {
            if let dataSource = newValue as? BsCollectionViewDataSource {
                super.dataSource = dataSource
                proxy.dataSource = dataSource
            }
            else {
                super.dataSource = newValue
            }
        }
        get {
            proxy.dataSource
        }
    }
    
    open override var delegate: UICollectionViewDelegate? {
        set {
            guard let newValue else {
                proxy.target = nil
                return
            }
            if !(newValue is BsCollectionViewProxy) {
                proxy.target = newValue
            }
            super.delegate = proxy
        }
        get {
            super.delegate
        }
    }
    
    // MARK: - Register
    
    open override func register(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        super.register(cellClass, forCellWithReuseIdentifier: identifier)
        registryMap[identifier] = cellClass
    }
    
    open override func register(_ nib: UINib?, forCellWithReuseIdentifier identifier: String) {
        super.register(nib, forCellWithReuseIdentifier: identifier)
        registryMap[identifier] = nib
    }
    
    open override func register(_ viewClass: AnyClass?,
                                forSupplementaryViewOfKind elementKind: String,
                                withReuseIdentifier identifier: String) {
        super.register(viewClass, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: identifier)
        registryMap[identifier] = viewClass
    }
    
    open override func register(_ nib: UINib?,
                                forSupplementaryViewOfKind kind: String,
                                withReuseIdentifier identifier: String) {
        super.register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
        registryMap[identifier] = nib
    }

    // MARK: - Additions

    open func append(section: BsCollectionViewSection) {
        proxy.dataSource.append(section)
    }

    open func insert(_ section: BsCollectionViewSection, at index: Int) {
        proxy.dataSource.insert(section, at: index)
    }

    open func remove(_ section: BsCollectionViewSection) {
        proxy.dataSource.remove(section)
    }

    open func removeAll() {
        proxy.dataSource.removeAll()
    }
    
    open func setDataSource(_ newValue: BsCollectionViewDataSource?) {
        dataSource = newValue
    }
}

// MARK: - Registry

extension BsCollectionView {
    final func registerCellIfNeeded(_ item: BsCollectionViewNode) {
        let id = item.reuseIdentifier
        if registryMap.contains(where: { $0.key == id }) {
            return
        }
        
        if let nib = item.nib {
            register(nib, forCellWithReuseIdentifier: id)
        }
        else {
            register(item.cellClass, forCellWithReuseIdentifier: id)
        }
    }
    
    final func registerHeaderIfNeeded(_ section: BsCollectionViewSection) {
        let id = section.headerReuseIdentifier
        if registryMap.contains(where: { $0.key == id }) {
            return
        }

        if let nib = section.headerNib {
            register(nib,
                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                     withReuseIdentifier: id)
        }
        else {
            register(section.headerClass,
                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                     withReuseIdentifier: id)
        }
    }

    final func registerFooterIfNeeded(_ section: BsCollectionViewSection) {
        let id = section.footerReuseIdentifier
        if registryMap.contains(where: { $0.key == id }) {
            return
        }

        if let nib = section.footerNib {
            register(nib,
                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                     withReuseIdentifier: id)
        }
        else {
            register(section.footerClass,
                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,               
                     withReuseIdentifier: id)
        }
    }
}

// MARK: - Extensions

public extension BaldStudio where Hair: BsCollectionView {
    var dataSource: BsCollectionViewDataSource { this.proxy.dataSource }
}
