//
//  CollectionView+DataSource.swift
//  BsFoundation
//
//  Created by crzorz on 2021/7/12.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import UIKit

extension CollectionView {
    open class DataSource: NSObject, UICollectionViewDataSource, NodeRepresentable {
        var registryMap: Dictionary<String, Any> = [:]
                
        func isRegistered(_ id: String) -> Bool {
            registryMap.contains { (key: String, value: Any) in
                key == id
            }
        }
        
        public typealias Parent = CollectionView
        public typealias Child = Section

        public weak internal(set) var parent: Parent? = nil
        public var children: ContiguousArray<Child> = []
        
        public func append(_ child: Child) {
            if let p = child.parent {
                p.remove(child)
                child.parent = nil
            }

            children.append(child)
            child.parent = self
        }
              
        public func insert(_ child: Child, at i: Int) {
            if let p = child.parent {
                p.remove(child)
                child.parent = nil
            }

            children.insert(child, at: i)
            child.parent = self
        }
        
        public func remove(at index: Int) {
            children[index].parent = nil
            children.remove(at: index)
        }
        
        public func removeFromParent() {}
        
        public subscript(index: Int) -> Child {
            get {
                children[index]
            }
            set {
                if let p = newValue.parent {
                    p.remove(newValue)
                    newValue.parent = nil
                }

                children[index] = newValue
                newValue.parent = self
            }
        }

        public subscript(_ indexPath: IndexPath) -> Child.Child {
            get {
                self[indexPath.section][indexPath.item]
            }
        }
        
        public func numberOfSections(in collectionView: UICollectionView) -> Int {
            children.count
        }
        
        public func collectionView(_ collectionView: UICollectionView,
                                   numberOfItemsInSection section: Int) -> Int {
            self[section].children.count
        }
        
        public func collectionView(_ collectionView: UICollectionView,
                                   cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let item = self[indexPath]
            let reuseID = item.reuseIdentifier
            
            if !isRegistered(reuseID) {
                if let nibItem = item as? NibLoadable {
                    collectionView.register(nibItem.nib, forCellWithReuseIdentifier: reuseID)
                }
                else {
                    collectionView.register(item.cellClass, forCellWithReuseIdentifier: reuseID)
                }
            }

            return item.collectionView(collectionView, cellForItemAt: indexPath)
        }

    }
}
