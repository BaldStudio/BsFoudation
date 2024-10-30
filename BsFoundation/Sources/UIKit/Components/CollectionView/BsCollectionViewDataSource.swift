//
//  BsCollectionViewDataSource.swift
//  BsFoundation
//
//  Created by changrunze on 2023/6/30.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

// MARK: - Property

open class BsCollectionViewDataSource: NSObject {
    public typealias Parent = BsCollectionView
    public typealias Child = BsCollectionViewSection

    open internal(set) weak var parent: Parent?
    
    open var collectionView: BsCollectionView? { parent }

    open var children: ContiguousArray<Child> = []
    
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
    
    open subscript(indexPath: IndexPath) -> Child.Child {
        set {
            self[indexPath.section][indexPath.item] = newValue
        }
        get {
            self[indexPath.section][indexPath.item]
        }
    }
}

// MARK: - DataSource Delegate

extension BsCollectionViewDataSource: UICollectionViewDataSource {
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        count
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self[section].count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let parent else {
            fatalError("tableView dataSource is null")
        }
        return self[indexPath].collectionView(parent, cellForItemAt: indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView, 
                             viewForSupplementaryElementOfKind kind: String,
                             at indexPath: IndexPath) -> UICollectionReusableView {
        guard let parent else {
            fatalError("tableView dataSource is null")
        }

        if kind == UICollectionView.elementKindSectionHeader {
            return self[indexPath.section].collectionView(parent, viewForHeaderAt: indexPath)
        }
        
        if kind == UICollectionView.elementKindSectionFooter {
            return self[indexPath.section].collectionView(parent, viewForFooterAt: indexPath)
        }
        
        return self[indexPath.section].collectionView(parent,
                                                      viewForSupplementaryElementOfKind: kind,
                                                      at: indexPath)
    }
}

// MARK: - Operator

public extension BsCollectionViewDataSource {
    static func += (left: BsCollectionViewDataSource, right: Child) {
        left.append(right)
    }
    
    static func -= (left: BsCollectionViewDataSource, right: Child) {
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
