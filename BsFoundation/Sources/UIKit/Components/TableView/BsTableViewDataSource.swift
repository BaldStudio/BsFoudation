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
        child.removeFromParent()
        children.append(child)
        child.parent = self
    }
    
    open func append(children: [Child]) {
        children.forEach { append($0) }
    }
    
    open func insert(_ child: Child, at index: Int) {
        guard isValidIndex(index) else {
            logger.debug("Invalid index When Insert Section at \(index)")
            return
        }
        child.removeFromParent()
        children.insert(child, at: index)
        child.parent = self
    }
    
    open func replaceChild(at index: Int, with newChild: Child) {
        guard isValidIndex(index) else {
            logger.debug("Invalid index When Replace Section at \(index)")
            return
        }
        newChild.removeFromParent()
        children[index] = newChild
        newChild.parent = self
    }
    
    open func remove(at index: Int) {
        guard isValidIndex(index) else {
            logger.debug("Invalid index When Remove Section at \(index)")
            return
        }
        let child = children[index]
        children.remove(at: index)
        child.parent = nil
    }
    
    open func remove(_ child: Child) {
        guard let index = index(of: child) else {
            logger.error("Invalid index When Remove Section \(child)")
            return
        }
        children.remove(at: index)
        child.parent = nil
    }
    
    open func remove(children: [Child]) {
        children.reversed().forEach { remove($0) }
    }
    
    open func removeAll() {
        children.reversed().forEach { remove($0) }
    }
    
    open func removeFromParent() {
        guard let parent else { return }
        parent.dataSource = nil
    }

    open func child(at index: Int) -> Child {
        children[index]
    }
    
    open func index(of child: Child) -> Int? {
        children.firstIndex(of: child)
    }
    
    open func contains(_ child: Child) -> Bool {
        children.contains(child)
    }
    
    open func contains(where predicate: (Child) throws -> Bool) rethrows -> Bool {
        try children.contains(where: predicate)
    }
    
    open subscript(index: Int) -> Child? {
        set {
            if let newValue {
                replaceChild(at: index, with: newValue)
            } else {
                remove(at: index)
            }
        }
        get {
            isValidIndex(index) ? children[index] : nil
        }
    }
    
    open subscript(indexPath: IndexPath) -> Child.Child? {
        set {
            self[indexPath.section]?[indexPath.row] = newValue
        }
        get {
            self[indexPath.section]?[indexPath.row]
        }
    }
}

private extension BsTableViewDataSource {
    func isValidIndex(_ index: Int) -> Bool {
        children.indices.contains(index)
    }
}

// MARK: - UITableViewDataSource

extension BsTableViewDataSource: UITableViewDataSource {
    open func numberOfSections(in tableView: UITableView) -> Int {
        count
    }
    
    open func tableView(_ tableView: UITableView,
                        numberOfRowsInSection section: Int) -> Int {
        self[section]?.count ?? 0
    }
    
    open func tableView(_ tableView: UITableView,
                        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let parent, let row = self[indexPath] else {
            return UITableViewCell()
        }
        return row.tableView(parent, cellForRowAt: indexPath)
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
