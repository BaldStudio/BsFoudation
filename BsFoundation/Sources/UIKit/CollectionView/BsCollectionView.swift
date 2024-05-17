//
//  BsCollectionView.swift
//  BsFoundation
//
//  Created by changrunze on 2023/6/30.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

// MARK: - Property

open class BsCollectionView: UICollectionView {
    private var proxy = BsCollectionViewProxy()
    fileprivate var _dataSource = BsCollectionViewDataSource()
    
    open private(set) var registryMap: [String: AnyObject] = [:]

    deinit {
        logger.debug("\(self.classForCoder) -> deinit 🔥")
    }
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    public convenience init(delegate: UICollectionViewDelegate?) {
        self.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        self.delegate = delegate
    }

    public convenience init(with layout: UICollectionViewLayout) {
        self.init(frame: .zero, collectionViewLayout: layout)
        self.delegate = delegate
    }
    
    open func commonInit() {
        backgroundColor = .white
        delegate = proxy
        dataSource = _dataSource
        proxy.collectionView = self
    }
    
    // MARK: - Override

    open override var dataSource: UICollectionViewDataSource? {
        set {
            if let dataSource = newValue as? BsCollectionViewDataSource {
                super.dataSource = dataSource
                _dataSource = dataSource
                proxy.dataSource = dataSource
                dataSource.collectionView = self
            }
            else {
                super.dataSource = newValue
            }
        }
        get {
            _dataSource
        }
    }
    
    open override var delegate: UICollectionViewDelegate? {
        set {
            guard let newValue = newValue else {
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
        _dataSource.append(section)
    }

    open func insert(_ section: BsCollectionViewSection, at index: Int) {
        _dataSource.insert(section, at: index)
    }

    open func remove(_ section: BsCollectionViewSection) {
        _dataSource.remove(section)
    }

    open func removeAll() {
        _dataSource.removeAll()
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

public extension BaldStudio where T: BsCollectionView {
    var dataSource: BsCollectionViewDataSource { this._dataSource }
}
