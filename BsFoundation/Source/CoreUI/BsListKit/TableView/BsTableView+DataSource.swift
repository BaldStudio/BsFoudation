//
//  BsTableView+DataSource.swift
//  BsFoundation
//
//  Created by crzorz on 2021/7/8.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import UIKit

extension BsTableView {
    public class DataSource: NSObject, UITableViewDataSource, NodeRepresentable {
        var registryMap: Dictionary<String, Any> = [:]
                
        func isRegistered(_ id: String) -> Bool {
            registryMap.contains { (key: String, value: Any) in
                key == id
            }
        }
        
        public typealias Parent = BsTableView
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
        
        public subscript(indexPath: IndexPath) -> Child.Child {
            get {
                self[indexPath.section].children[indexPath.row]
            }
        }
        
        public func numberOfSections(in tableView: UITableView) -> Int {
            children.count
        }
        
        public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            self[section].children.count
        }
        
        public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let a = self[indexPath]
            let row = self[indexPath]
            let reuseID = row.reuseIdentifier            
            if !isRegistered(reuseID) {
                if let nibRow = row as? NibLoadable {
                    tableView.register(nibRow.nib, forCellReuseIdentifier: reuseID)
                }
                else {
                    tableView.register(row.cellClass, forCellReuseIdentifier: reuseID)
                }
            }

            return row.tableView(tableView, cellForRowAt: indexPath)
        }

    }

}
