//
//  BsCollectionViewSection.swift
//  BsFoundation
//
//  Created by changrunze on 2023/6/30.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

// MARK: - Property

open class BsCollectionViewSection: NSObject {
    public typealias Parent = BsCollectionViewDataSource
    public typealias Child = BsCollectionViewNode

    open weak internal(set) var parent: Parent? = nil
    
    open var collectionView: BsCollectionView? { parent?.parent }

    open var children: ContiguousArray<Child> = []
    
    open var insets: UIEdgeInsets = .zero
    open var minimumLineSpacing: CGFloat = 0
    open var minimumInteritemSpacing: CGFloat = 0

    deinit {
        logger.debug("\(self.classForCoder) -> deinit 🔥")
    }

    public override init() {
        super.init()
    }
            
    open func reload() {
        guard let collectionView = collectionView,
              let section = index else { return }
        collectionView.reloadSections([section])
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

    open var headerSize: CGSize = .zero
    
    open var headerClass: UICollectionReusableView.Type = UICollectionReusableView.self
    
    open var headerNib: UINib? = nil

    open var headerReuseIdentifier: String {
        "\(Self.self).\(headerClass).Header"
    }
    
    open var headerView: UICollectionReusableView? {
        guard let index = index,
              let collectionView = collectionView else {
            return nil
        }

        return collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader,
                                                at: IndexPath(index: index))
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
    
    open func update(header: UICollectionReusableView,
                     at indexPath: IndexPath) {}
        
    open func willDisplay(header: UICollectionReusableView,
                          at indexPath: IndexPath) {}
    
    open func didEndDisplaying(header: UICollectionReusableView,
                               at indexPath: IndexPath) {}

    // MARK: - Footer

    open var footerSize: CGSize = .zero

    open var footerClass: UICollectionReusableView.Type = UICollectionReusableView.self
    
    open var footerNib: UINib? = nil

    open var footerReuseIdentifier: String {
        "\(Self.self).\(footerClass).Footer"
    }
    
    open var footerView: UICollectionReusableView? {
        guard let index = index,
              let collectionView = collectionView else {
            return nil
        }

        return collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter,
                                                at: IndexPath(index: index))
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
    
    open func update(footer: UICollectionReusableView,
                     at indexPath: IndexPath) {}
    
    open func willDisplay(footer: UICollectionReusableView,
                          at indexPath: IndexPath) {}
    
    open func didEndDisplaying(footer: UICollectionReusableView,
                               at indexPath: IndexPath) {}

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
    static func += (left: BsCollectionViewSection, right: Child) {
        left.append(right)
    }
    
    static func -= (left: BsCollectionViewSection, right: Child) {
        left.remove(right)
    }
}
