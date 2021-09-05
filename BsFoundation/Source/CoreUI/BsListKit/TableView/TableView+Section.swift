//
//  TableView+Section.swift
//  BsFoundation
//
//  Created by crzorz on 2021/7/8.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import UIKit

extension TableView {
    open class Section: NodeRepresentable {
        public init() {}
        
        public typealias Parent = DataSource
        public typealias Child = Row

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

        public func removeFromParent() {
            parent?.remove(self)
        }

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

        public var index: Int? {
            parent?.children.firstIndex(of: self)
        }

        open func reload(with animation: RowAnimation = .none) {
            guard let tableView = parent?.parent, let i = index else { return }
            tableView.reloadSections([i], with: animation)
        }
        
        // MARK: - Section Header
        
        open var headerViewClass: AnyClass = UITableViewHeaderFooterView.self

        open var headerHeight: CGFloat = 0.0
        
        open var headerReuseIdentifier: String {
            "\(Self.self)\(headerViewClass)Header"
        }
                
        open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            headerHeight
        }

        open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {            
            var headView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerReuseIdentifier)
            headView = updateHeaderView?(headView, section)
            return headView
        }

        open func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
            willDisplayHeaderView?(view, section)
        }
        
        open func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
            didEndDisplayingHeaderView?(view, section)
        }

        // MARK: - Section Footer
        open var footerViewClass: AnyClass = UITableViewHeaderFooterView.self

        open var footerHeight: CGFloat = 0.0
        
        open var footerReuseIdentifier: String {
            "\(Self.self)\(footerViewClass)Footer"
        }
        
        open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            footerHeight
        }
        
        open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            var footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: footerReuseIdentifier)
            footerView = updateFooterView?(footerView, section)
            return footerView
        }
        
        open func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
            willDisplayFooterView?(view, section)
        }
        
        open func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
            didEndDisplayingFooterView?(view, section)
        }

        // MARK: - Closure

        public var updateHeaderView: ((UITableViewHeaderFooterView?, Int) -> UITableViewHeaderFooterView?)?
        public var willDisplayHeaderView: ((UIView, Int) -> Void)?
        public var didEndDisplayingHeaderView: ((UIView, Int) -> Void)?

        public var updateFooterView: ((UITableViewHeaderFooterView?, Int) -> UITableViewHeaderFooterView?)?
        public var willDisplayFooterView: ((UIView, Int) -> Void)?
        public var didEndDisplayingFooterView: ((UIView, Int) -> Void)?

    }
}

extension TableView.Section: Equality {}
