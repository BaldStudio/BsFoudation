//
//  BsTableViewDataSource.swift
//  BsFoundation
//
//  Created by changrunze on 2023/6/7.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

// MARK: - Property

open class BsTableViewDataSource: NSObject {
    public typealias Parent = BsTableView
    public typealias Child = BsTableViewSection
    
    open internal(set) weak var parent: Parent? = nil

    open var tableView: BsTableView? { parent }

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
    
    open var first: Child? {
        children.first
    }
    
    open var last: Child? {
        children.last
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
        guard let parent else { return }
        parent.setDataSource(nil)
    }

    open func child(at index: Int) -> Child {
        children[index]
    }
    
    open func contains(_ child: Child) -> Bool {
        children.contains { $0 == child }
    }
    
    open func contains(where predicate: (Child) throws -> Bool) rethrows -> Bool {
        try children.contains(where: predicate)
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
            self[indexPath.section][indexPath.row] = newValue
        }
        get {
            self[indexPath.section][indexPath.row]
        }
    }
}

// MARK: - UITableViewDataSource

extension BsTableViewDataSource: UITableViewDataSource {
    open func numberOfSections(in tableView: UITableView) -> Int {
        count
    }
    
    open func tableView(_ tableView: UITableView,
                        numberOfRowsInSection section: Int) -> Int {
        self[section].count
    }
    
    open func tableView(_ tableView: UITableView,
                        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let parent else {
            fatalError("tableView dataSource is null")
        }
        return self[indexPath].tableView(parent, cellForRowAt: indexPath)
    }
}

// MARK: - Operator

public extension BsTableViewDataSource {
    static func += (left: BsTableViewDataSource, right: Child) {
        left.append(right)
    }
    
    static func -= (left: BsTableViewDataSource, right: Child) {
        left.remove(right)
    }
}

// MARK: -  Description

extension BsTableViewDataSource {
    open override var description: String {
        var text = "\(self)"
        if children.isNotEmpty {
            text = " {" + children.map { $0.description }.joined(separator: ", ") + "} "
        }
        return text
    }
}
