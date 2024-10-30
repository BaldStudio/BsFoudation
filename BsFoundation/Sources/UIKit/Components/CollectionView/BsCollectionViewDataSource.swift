//
//  BsCollectionViewDataSource.swift
//  BsFoundation
//
//  Created by changrunze on 2023/6/30.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

// MARK: - Property

open class BsCollectionViewDataSource: NSObject {
    public typealias SectionType = BsCollectionViewSection

    open internal(set) weak var parent: BsCollectionView?
    
    open var collectionView: BsCollectionView? { parent }

    var children: ContiguousArray<SectionType> = []
    
    deinit {
        logger.debug("\(classForCoder) -> deinit 🔥")
    }

    public override init() {
        super.init()
    }
    
    // MARK: - Node Actions
    
    open var count: Int {
        children.count
    }
    
    open var isEmpty: Bool {
        children.isEmpty
    }
    
    open func append(_ child: SectionType) {
        child.removeFromParent()
        children.append(child)
        child.parent = self
    }
        
    open func insert(_ child: SectionType, at index: Int) {
        guard children.hasIndex(index) else {
            logger.error("Invalid index When Insert Section at \(index)")
            return
        }
        child.removeFromParent()
        children.insert(child, at: index)
        child.parent = self
    }
    
    open func replaceChild(at index: Int, with newChild: SectionType) {
        guard children.hasIndex(index) else {
            logger.error("Invalid index When Replace Section at \(index)")
            return
        }
        newChild.removeFromParent()
        children[index] = newChild
        newChild.parent = self
    }
    
    open func remove(at index: Int) {
        guard children.hasIndex(index) else {
            logger.error("Invalid index When Remove Section at \(index)")
            return
        }
        let child = children[index]
        children.remove(at: index)
        child.parent = nil
    }
    
    open func remove(_ child: SectionType) {
        guard let index = index(of: child) else {
            logger.error("Invalid index When Remove Section \(child)")
            return
        }
        children.remove(at: index)
        child.parent = nil
    }
    
    open func removeAll() {
        children.reversed().forEach { $0.removeFromParent() }
    }
    
    open func removeFromParent() {
        parent?.dataSource = nil
    }

    open func child(at index: Int) -> SectionType? {
        guard children.hasIndex(index) else {
            logger.error("Invalid index When Get Row at \(index)")
            return nil
        }
        return children[index]
    }
    
    open func index(of child: SectionType) -> Int? {
        children.firstIndex(of: child)
    }
    
    open func contains(_ child: SectionType) -> Bool {
        children.contains(child)
    }
    
    open func contains(where predicate: (SectionType) throws -> Bool) rethrows -> Bool {
        try children.contains(where: predicate)
    }
    
    open subscript(index: Int) -> SectionType? {
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
    
    open subscript(indexPath: IndexPath) -> SectionType.ItemType? {
        set {
            self[indexPath.section]?[indexPath.row] = newValue
        }
        get {
            self[indexPath.section]?[indexPath.row]
        }
    }
}

// MARK: - DataSource Delegate

extension BsCollectionViewDataSource: UICollectionViewDataSource {
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        count
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self[section]?.count ?? 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, 
                             cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let parent, let item = self[indexPath]?.inner else {
            return UICollectionViewCell()
        }
        return item.collectionView(parent, cellForItemAt: indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView, 
                             viewForSupplementaryElementOfKind kind: String,
                             at indexPath: IndexPath) -> UICollectionReusableView {
        guard let parent, let sect = self[indexPath.section] else {
            return UICollectionReusableView()
        }

        if kind == UICollectionView.elementKindSectionHeader {
            return sect.collectionView(parent, viewForHeaderAt: indexPath)
        }
        
        if kind == UICollectionView.elementKindSectionFooter {
            return sect.collectionView(parent, viewForFooterAt: indexPath)
        }
        
        return sect.collectionView(parent, viewForSupplementaryElementOfKind: kind, at: indexPath)
    }
}

// MARK: - Operator

public extension BsCollectionViewDataSource {
    static func += (left: BsCollectionViewDataSource, right: SectionType) {
        left.append(right)
    }
    
    static func -= (left: BsCollectionViewDataSource, right: SectionType) {
        left.remove(right)
    }
}

// MARK: -  Description

extension BsCollectionViewDataSource {
    open override var description: String {
        var text = "\(self)"
        if children.isNotEmpty {
            text = " {" + children.map { $0.description }.joined(separator: ", ") + "} "
        }
        return text
    }
}

// MARK: -  Sequence

extension BsCollectionViewDataSource: Sequence {
    public func makeIterator() -> AnyIterator<SectionType> {
        var index = 0
        return AnyIterator {
            guard index < self.children.count else { return nil }
            let sect = self.children[index]
            index += 1
            return sect
        }
    }
}
