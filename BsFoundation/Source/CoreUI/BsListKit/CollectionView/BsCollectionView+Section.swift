//
//  BsCollectionView+Section.swift
//  BsFoundation
//
//  Created by crzorz on 2021/7/12.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import UIKit

extension BsCollectionView {
    open class Section: NodeRepresentable {
        static let headerKind = UICollectionView.elementKindSectionHeader
        static let footerKind = UICollectionView.elementKindSectionFooter

        public init() {}
        
        public typealias Parent = DataSource
        public typealias Child = Item

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
        
        open var insets: UIEdgeInsets = .zero
        open var minimumLineSpacing: CGFloat = 0
        open var minimumInteritemSpacing: CGFloat = 0

        // MARK: - Section Header
        open var headerSize: CGSize = .zero
        
        open var headerClass: AnyClass = UICollectionReusableView.self
        
        open var headerReuseIdentifier: String {
            return "\(Self.self)Header"
        }
        
        open func reload() {
            guard let collectionView = parent?.parent,
                  let s = index else { return }
            collectionView.reloadSections([s])
        }
        
        open func collectionView(_ collectionView: UICollectionView,
                                 viewForHeaderAt indexPath: IndexPath) -> UICollectionReusableView {
            var header = collectionView.dequeueReusableSupplementaryView(ofKind: Self.headerKind,
                                                            withReuseIdentifier: headerReuseIdentifier,
                                                            for: indexPath)
            if updateHeaderView != nil {
                header = updateHeaderView!(header, indexPath)
            }
            return header
        }
        
        open func collectionView(_ collectionView: UICollectionView,
                                 willDisplayHeaderView view: UICollectionReusableView,
                                 at indexPath: IndexPath) {
            willDisplayHeaderView?(view, indexPath)
        }

        open func collectionView(_ collectionView: UICollectionView,
                                 didEndDisplayingHeaderView view: UICollectionReusableView,
                                 at indexPath: IndexPath) {
            didEndDisplayingHeaderView?(view, indexPath)

        }

        // MARK: - Section Footer
        open var footerSize: CGSize = .zero
        
        open var footerClass: AnyClass = UICollectionReusableView.self
        
        open var footerReuseIdentifier: String {
            return "\(Self.self)Footer"
        }
        
        open func collectionView(_ collectionView: UICollectionView,
                                 viewForFooterAt indexPath: IndexPath) -> UICollectionReusableView {
            var footer = collectionView.dequeueReusableSupplementaryView(ofKind: Self.footerKind,
                                                            withReuseIdentifier: footerReuseIdentifier,
                                                            for: indexPath)
            if updateHeaderView != nil {
                footer = updateFooterView!(footer, indexPath)
            }
            return footer

        }
        
        open func collectionView(_ collectionView: UICollectionView,
                                 willDisplayFooterView view: UICollectionReusableView,
                                 at indexPath: IndexPath) {
            willDisplayFooterView?(view, indexPath)

        }

        open func collectionView(_ collectionView: UICollectionView,
                                 didEndDisplayingFooterView view: UICollectionReusableView,
                                 at indexPath: IndexPath) {
            didEndDisplayingFooterView?(view, indexPath)

        }
        
        // MARK: - Closure

        public var updateHeaderView: ((UICollectionReusableView?, IndexPath) -> UICollectionReusableView)?
        public var willDisplayHeaderView: ((UICollectionReusableView, IndexPath) -> Void)?
        public var didEndDisplayingHeaderView: ((UICollectionReusableView, IndexPath) -> Void)?

        public var updateFooterView: ((UICollectionReusableView?, IndexPath) -> UICollectionReusableView)?
        public var willDisplayFooterView: ((UICollectionReusableView, IndexPath) -> Void)?
        public var didEndDisplayingFooterView: ((UICollectionReusableView, IndexPath) -> Void)?

    }
}

extension BsCollectionView.Section: Equality {}
