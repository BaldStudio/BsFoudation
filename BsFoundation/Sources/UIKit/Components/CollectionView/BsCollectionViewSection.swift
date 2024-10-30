//
//  BsCollectionViewSection.swift
//  BsFoundation
//
//  Created by changrunze on 2023/6/30.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

// MARK: - Property

open class BsCollectionViewSection: NSObject {
    public typealias ItemType = BsCollectionViewItemRepresentable

    open weak internal(set) var parent: BsCollectionViewDataSource? = nil
    
    open var collectionView: BsCollectionView? { parent?.parent }

    var children: ContiguousArray<ItemType> = []
    
    open var insets: UIEdgeInsets = .zero
    open var minimumLineSpacing: CGFloat = 0
    open var minimumInteritemSpacing: CGFloat = 0

    deinit {
        logger.debug("\(classForCoder) -> deinit 🔥")
    }

    public override init() {
        super.init()
    }
            
    open func reload() {
        guard let collectionView, let section else { return }
        collectionView.reloadSections([section])
    }

    // MARK: - Node Actions
    
    open var count: Int {
        children.count
    }
    
    open var isEmpty: Bool {
        children.isEmpty
    }
    
    open var section: Int? {
        parent?.index(of: self)
    }
    
    open func append(_ child: ItemType) {
        child.inner.removeFromParent()
        children.append(child)
        child.inner.parent = self
    }
        
    open func insert(_ child: ItemType, at index: Int) {
        guard children.hasIndex(index) else {
            logger.error("Invalid index When Insert Row at \(index)")
            return
        }
        child.inner.removeFromParent()
        children.insert(child, at: index)
        child.inner.parent = self
    }
    
    open func replaceChild(at index: Int, with newChild: ItemType) {
        guard children.hasIndex(index) else {
            logger.error("Invalid index When Replace Row at \(index)")
            return
        }
        newChild.inner.removeFromParent()
        children[index] = newChild
        newChild.inner.parent = self
    }
    
    open func remove(at index: Int) {
        guard children.hasIndex(index) else {
            logger.error("Invalid index When Remove Row at \(index)")
            return
        }
        let child = children[index]
        children.remove(at: index)
        child.inner.parent = nil
    }
    
    open func remove(_ child: ItemType) {
        guard let index = index(of: child) else {
            logger.error("Invalid index When Remove Row \(child)")
            return
        }
        children.remove(at: index)
        child.inner.parent = nil
    }
        
    open func removeAll() {
        children.reversed().forEach { remove($0) }
    }
    
    open func removeFromParent() {
        parent?.remove(self)
    }
    
    open func child(at index: Int) -> ItemType? {
        guard children.hasIndex(index) else {
            logger.error("Invalid index When Get Row at \(index)")
            return nil
        }
        return children[index]
    }
    
    open func index(of child: ItemType) -> Int? {
        children.firstIndex { $0 === child }
    }
    
    open func contains(_ child: ItemType) -> Bool {
        children.contains { $0 === child }
    }
    
    open func contains(where predicate: (ItemType) throws -> Bool) rethrows -> Bool {
        try children.contains(where: predicate)
    }

    open subscript(index: Int) -> ItemType? {
        set {
            if let newValue {
                replaceChild(at: index, with: newValue)
            } else {
                remove(at: index)
            }
        }
        get {
            child(at: index)
        }
    }

    // MARK: - Header

    open var headerSize: CGSize = .zero
    
    open var headerClass: UICollectionReusableView.Type = UICollectionReusableView.self
    
    open var headerNib: UINib? = nil

    open var headerReuseIdentifier: String {
        "\(Self.self).\(headerClass).Header"
    }
    
    open var headerView: UICollectionReusableView? {
        guard let section, let collectionView else { return nil }
        return collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader,
                                                at: IndexPath(index: section))
    }

    open func collectionView(_ collectionView: BsCollectionView,
                             viewForHeaderAt indexPath: IndexPath) -> UICollectionReusableView {
        collectionView.registerHeaderIfNeeded(self)
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                               withReuseIdentifier: headerReuseIdentifier,
                                                               for: indexPath)
        update(header: view, at: indexPath)
        return view
    }
    
    open func update(header: UICollectionReusableView, at indexPath: IndexPath) {}
        
    open func willDisplay(header: UICollectionReusableView, at indexPath: IndexPath) {}
    
    open func didEndDisplaying(header: UICollectionReusableView, at indexPath: IndexPath) {}

    // MARK: - Footer

    open var footerSize: CGSize = .zero

    open var footerClass: UICollectionReusableView.Type = UICollectionReusableView.self
    
    open var footerNib: UINib? = nil

    open var footerReuseIdentifier: String {
        "\(Self.self).\(footerClass).Footer"
    }
    
    open var footerView: UICollectionReusableView? {
        guard let section, let collectionView else { return nil }
        return collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter,
                                                at: IndexPath(index: section))
    }

    open func collectionView(_ collectionView: BsCollectionView,
                             viewForFooterAt indexPath: IndexPath) -> UICollectionReusableView {
        collectionView.registerFooterIfNeeded(self)
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                                               
                                                                   withReuseIdentifier: footerReuseIdentifier,
                                                               for: indexPath)
        update(footer: view, at: indexPath)
        return view
    }
    
    open func update(footer: UICollectionReusableView, at indexPath: IndexPath) {}
    
    open func willDisplay(footer: UICollectionReusableView, at indexPath: IndexPath) {}
    
    open func didEndDisplaying(footer: UICollectionReusableView, at indexPath: IndexPath) {}

    // MARK: - Supplementary
    
    open func collectionView(_ collectionView: BsCollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        fatalError("需要子类重写")
    }
    
    open func collectionView(_ collectionView: BsCollectionView,
                             willDisplaySupplementaryView view: UICollectionReusableView,
                             forElementKind elementKind: String,
                             at indexPath: IndexPath) {}

    open func collectionView(_ collectionView: BsCollectionView,
                             didEndDisplayingSupplementaryView view: UICollectionReusableView,
                             forElementOfKind elementKind: String, at indexPath: IndexPath) {}
}

// MARK: - Operator

public extension BsCollectionViewSection {
    static func += (left: BsCollectionViewSection, right: ItemType) {
        left.append(right)
    }
    
    static func -= (left: BsCollectionViewSection, right: ItemType) {
        left.remove(right)
    }
}

// MARK: -  Description

extension BsCollectionViewSection {
    open override var description: String {
        var text = "\(self)"
        if children.isNotEmpty {
            text = " {" + children.map { $0.description }.joined(separator: ", ") + "} "
        }
        return text
    }
}

// MARK: -  Utils

public extension BsCollectionViewSection {
    var viewController: UIViewController? {
        collectionView?.viewController
    }
    
    var navigationController: UINavigationController? {
        collectionView?.navigationController
    }
}

// MARK: -  Sequence

extension BsCollectionViewSection: Sequence {
    public func makeIterator() -> AnyIterator<ItemType> {
        var index = 0
        return AnyIterator {
            guard index < self.children.count else { return nil }
            let row = self.children[index]
            index += 1
            return row
        }
    }
}
