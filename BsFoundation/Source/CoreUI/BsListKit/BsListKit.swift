//
//  BsListKit.swift
//  BsFoundation
//
//  Created by crzorz on 2021/7/9.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import UIKit

let fittingSize = UIView.layoutFittingCompressedSize

// MARK: - Equality

protocol Equality: AnyObject, Equatable {}

extension Equality {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        ObjectIdentifier(lhs).hashValue == ObjectIdentifier(rhs).hashValue
    }
}

// MARK: - Proxy

class Proxy: NSObject {
        
    weak var target: AnyObject?

    convenience init(_ target: AnyObject?) {
        self.init()
        self.target = target
    }
        
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if target?.responds(to: aSelector) == true {
            return target
        }
        return super.forwardingTarget(for: aSelector)
    }
    
    override func responds(to aSelector: Selector!) -> Bool {
        target?.responds(to: aSelector) == true || super.responds(to: aSelector)
    }
    
}

// MARK: - NibLoadable

public protocol NibLoadable {
    var nib: UINib { get }
}

public extension NibLoadable where Self: TableView.Row {
    var nib: UINib {
        return UINib(nibName: "\(self.cellClass)", bundle: Bundle(for: self.cellClass))
    }
}

public extension NibLoadable where Self: CollectionView.Item {
    var nib: UINib {
        return UINib(nibName: "\(self.cellClass)", bundle: Bundle(for: self.cellClass))
    }
}

// MARK: - NodeRepresentable

public protocol NodeRepresentable: AnyObject {
    associatedtype Parent
    associatedtype Child: Equatable

    var parent: Parent? { get }

    var children: ContiguousArray<Child> { get set }
    
    var count: Int { get }
    var isEmpty: Bool { get }
    
    subscript(index: Int) -> Child { get set }

    func append(_ child: Child)
    
    func append(children: [Child])
    
    func insert(_ child: Child, at i: Int)
    
    func remove(_ child: Child)
        
    func remove(at index: Int)
    
    func remove(children: [Child])

    func removeAll()
    
    func removeFromParent()
    
}

public extension NodeRepresentable {
    var count: Int {
        children.count
    }
    
    var isEmpty: Bool {
        children.count < 1
    }
    
    func append(children: [Child]) {
        for child in children {
            append(child)
        }
    }
        
    func remove(_ child: Child) {
        if let index = children.firstIndex(of: child) {
            remove(at: index)
        }
    }
    
    func remove(children: [Child]) {
        for child in children {
            remove(child)
        }
    }
        
    func removeAll() {
        for i in 0..<children.count {
            remove(at: i)
        }
    }
    
}
