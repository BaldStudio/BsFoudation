//
//  BsCollectionViewDataSource.swift
//  BsFoundation
//
//  Created by changrunze on 2023/6/30.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

// MARK: - Property

open class BsCollectionViewDataSource: NSObject {
    
    public typealias Child = BsCollectionViewSection

    open internal(set) weak var collectionView: BsCollectionView!

    open var children: ContiguousArray<Child> = []
    
    deinit {
        logger.debug("\(self.classForCoder) -> deinit 🔥")
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
        for child in children {
            append(child)
        }
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
        for child in children {
            remove(child)
        }
    }

    open func removeAll() {
        for i in 0..<children.count {
            remove(at: i)
        }
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
        self[indexPath].collectionView(self.collectionView, cellForItemAt: indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            return self[indexPath.section].collectionView(self.collectionView, viewForHeaderAt: indexPath)
        }
        
        if kind == UICollectionView.elementKindSectionFooter {
            return self[indexPath.section].collectionView(self.collectionView, viewForFooterAt: indexPath)
        }
        
        return self[indexPath.section].collectionView(self.collectionView,
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
