//
//  CollectionView+Item.swift
//  BsFoundation
//
//  Created by crzorz on 2021/7/12.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import UIKit

extension CollectionView {
    open class Item {
        
        var cellSizeCache: CGSize? = nil
        
        var cellSizeRawValue: CGSize {
            (cellSize as? _CollectionViewCellSize)?.bs_raw_size ?? .zero
        }
        
        public weak internal(set) var parent: Section? = nil
        
        public var indexPath: IndexPath? {
            guard let s = parent,
                let si = s.index,
                let r = parent?.children.firstIndex(of: self) else {
                return nil
            }
            return IndexPath(row: r, section: si)
        }

        public init() {
            
        }

        open internal(set) var fittingMode: AutofitMode = .none
        
        open var cellSize: CollectionViewCellSize = CGSize.zero

        open var cellClass: AnyClass = UICollectionViewCell.self

        open var reuseIdentifier: String {
            "\(Self.self)\(cellClass)"
        }
            
        open func invalidateCellSize() {
            cellSizeCache = nil
        }
        
        open func reload() {
            guard let collectionView = parent?.parent?.parent,
                  let i = indexPath else { return }
            collectionView.reloadItems(at: [i])
        }
                
        open func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        }
        
        open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
        }
        
        open func collectionView(_ collectionView: UICollectionView,
                                 willDisplay cell: UICollectionViewCell,
                                 forItemAt indexPath: IndexPath) {
            
        }
    }
}

extension CollectionView.Item: Equality {

    public enum AutofitMode {
        case none
        case fill
        case vertical   // 垂直方向自适应  as 定宽算高
        case horizontal // 水平方向自适应  as 定高算宽
    }
    
    func collectionView(_ collectionView: CollectionView, autofitItemSizeAt indexPath: IndexPath) -> CGSize {
        guard cellSizeCache == nil else {
            return cellSizeCache!
        }
        
        if fittingMode == .none {
            return .zero
        }
        
        let cell = collectionView.rootNode.collectionView(collectionView, cellForItemAt: indexPath)
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        var size = cellSizeRawValue
        if fittingMode == .vertical {
            size.height = fittingSize.height
            cellSizeCache = cell.contentView.systemLayoutSizeFitting(size,
                                                                     withHorizontalFittingPriority: .required,
                                                                     verticalFittingPriority: .fittingSizeLevel)
        }
        else if fittingMode == .horizontal {
            size.width = fittingSize.width
            cellSizeCache = cell.contentView.systemLayoutSizeFitting(size,
                                                                     withHorizontalFittingPriority: .fittingSizeLevel,
                                                                     verticalFittingPriority: .required)
        }
        else {
            cellSizeCache = cell.contentView.systemLayoutSizeFitting(size)
        }
                
        return cellSizeCache!;
    }

}

public protocol CollectionViewCellSize {}
private protocol _CollectionViewCellSize: CollectionViewCellSize {
    var bs_raw_size: CGSize { get }
}

extension CGSize: _CollectionViewCellSize {
    var bs_raw_size: CGSize {
        return self
    }
}

extension CGFloat: _CollectionViewCellSize {
    var bs_raw_size: CGSize {
        return CGSize(width: self, height: self)
    }
}

extension Float: _CollectionViewCellSize {
    var bs_raw_size: CGSize {
        return CGSize(width: CGFloat(self), height: CGFloat(self))
    }
}

extension Double: _CollectionViewCellSize {
    var bs_raw_size: CGSize {
        return CGSize(width: CGFloat(self), height: CGFloat(self))
    }
}

extension Int: _CollectionViewCellSize {
    var bs_raw_size: CGSize {
        return CGSize(width: CGFloat(self), height: CGFloat(self))
    }
}
