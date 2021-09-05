//
//  CollectionView.swift
//  BsFoundation
//
//  Created by crzorz on 2021/7/8.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import UIKit

open class CollectionView: UICollectionView {
    private var proxy = CollectionViewProxy()
    
    public private(set) var rootNode = DataSource()

    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = .white        
        dataSource = rootNode
        delegate = proxy
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var dataSource: UICollectionViewDataSource? {
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
                fatalError("the dataSource MUST be CollectionView.DataSource type")
            }
        }
    }
    
    public override var delegate: UICollectionViewDelegate? {
        set {
            if newValue == nil {
                super.delegate = nil
                return
            }
                         
            if !(newValue is CollectionViewProxy) {
                proxy.target = newValue
            }
            
            super.delegate = proxy
            
            proxy._dataSource = rootNode
            proxy._collectionView = self
        }
        get {
            super.delegate
        }
    }

    public override func register(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        super.register(cellClass, forCellWithReuseIdentifier: identifier)
        guard identifier != "com.apple.UIKit.shadowReuseCellIdentifier" else { return }
        rootNode.registryMap[identifier] = cellClass
    }
    
    open override func register(_ nib: UINib?, forCellWithReuseIdentifier identifier: String) {
        super.register(nib, forCellWithReuseIdentifier: identifier)
        rootNode.registryMap[identifier] = nib
    }
    
    open override func register(_ viewClass: AnyClass?,
                                forSupplementaryViewOfKind elementKind: String,
                                withReuseIdentifier identifier: String) {
        super.register(viewClass, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: identifier)
        rootNode.registryMap[identifier] = viewClass
    }
    
    open override func register(_ nib: UINib?,
                                forSupplementaryViewOfKind kind: String,
                                withReuseIdentifier identifier: String) {
        super.register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
        rootNode.registryMap[identifier] = nib
    }
}

private class CollectionViewProxy: Proxy, UICollectionViewDelegate {
    weak var _dataSource: CollectionView.DataSource!
    weak var _collectionView: CollectionView!

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        _dataSource[indexPath].collectionView(collectionView, didSelectItemAt: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        _dataSource[indexPath].collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplaySupplementaryView view: UICollectionReusableView,
                        forElementKind elementKind: String,
                        at indexPath: IndexPath) {
        if elementKind == CollectionView.Section.headerKind {
            return _dataSource[indexPath.section].collectionView(collectionView,
                                                                 willDisplayHeaderView: view,
                                                                 at: indexPath)
        }

        _dataSource[indexPath.section].collectionView(collectionView,
                                                      willDisplayFooterView: view,
                                                      at: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplayingSupplementaryView view: UICollectionReusableView,
                        forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == CollectionView.Section.headerKind {
            return _dataSource[indexPath.section].collectionView(collectionView,
                                                                 didEndDisplayingHeaderView: view,
                                                                 at: indexPath)
        }

        _dataSource[indexPath.section].collectionView(collectionView,
                                                      didEndDisplayingFooterView: view,
                                                      at: indexPath)
    }

}

extension CollectionViewProxy: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = _dataSource[indexPath]
        if item.fittingMode == .none {
            return item.cellSizeRawValue
        }

        return item.collectionView(_collectionView, autofitItemSizeAt: indexPath)

    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        _dataSource[section].insets
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        _dataSource[section].minimumLineSpacing
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        _dataSource[section].minimumInteritemSpacing
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        _dataSource[section].headerSize
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        _dataSource[section].footerSize
    }

}
