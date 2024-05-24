//
//  BsCollectionViewNode.swift
//  BsFoundation
//
//  Created by changrunze on 2023/8/18.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

/// 逻辑基类
open class BsCollectionViewNode: NSObject {
    public typealias Parent = BsCollectionViewSection
        
    var cellClass: UICollectionViewCell.Type { UICollectionViewCell.self }
    
    open internal(set) weak var parent: Parent? = nil
    
    open var collectionView: BsCollectionView? { parent?.collectionView }

    open var nib: UINib? = nil
    
    /// 指定 cell 的固定尺寸，在自适应尺寸时，则为自动计算方向上的最小值
    open var size: CGSize = .zero
    
    /// 自动计算尺寸的缓存
    var sizeCache: CGSize? = .zero

    /// 是否自动计算尺寸，vertical会自动算高，horizontal会自动算宽
    open var preferredLayoutSizeFitting: LayoutSizeFitting = .none
    
    /// 是否在视图主轴或纵轴方向撑满父视图，计算结果会改变 cellSize
    open var preferredLayoutSizeFixed: LayoutSizeFixed = .none

    /// 选中cell的回调闭包
    open var onSelectItem: BlockT<IndexPath>?

    deinit {
        logger.debug("\(self.classForCoder) -> deinit 🔥")
    }

    public override init() {
        super.init()
    }

    open var reuseIdentifier: String {
        "\(Self.self).\(cellClass).Cell"
    }
        
    open var cell: UICollectionViewCell? {
        guard let collectionView = collectionView,
              let indexPath = indexPath else {
            return nil
        }
        
        return collectionView.cellForItem(at: indexPath)
    }
    
    open var indexPath: IndexPath? {
        guard let parent = parent,
              let section = parent.index,
              let item = parent.children.firstIndex(of: self) else {
            return nil
        }
        
        return IndexPath(row: item, section: section)
    }
    
    open func reload() {
        guard let collectionView = collectionView,
              let indexPath = indexPath else { return }
        collectionView.reloadItems(at: [indexPath])
    }
    
    /// 重置cell的高度 会重新执行计算逻辑
    open func invalidateSize() {
        sizeCache = nil
    }
    
    // MARK: - Additions
    
    open func removeFromParent() {
        parent?.remove(self)
    }
    
    // MARK: - Cell
    
    func prepareLayoutSizeFitting(_ cell: UICollectionViewCell, at indexPath: IndexPath) {}

    func collectionView(_ collectionView: BsCollectionView, 
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.registerCellIfNeeded(self)
        return collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath)
    }

    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onSelectItem?(indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {}

    open func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {}

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {}
    
    func collectionView(_ collectionView: UICollectionView, 
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {}
}

// MARK: - Layout Fitting

extension BsCollectionViewNode {
    /// 自适应尺寸计算，如果计算不正确，请检查约束是否符合计算条件
    func collectionView(_ collectionView: UICollectionView, preferredLayoutSizeFittingAt indexPath: IndexPath) -> CGSize {
        if preferredLayoutSizeFitting == .none { return size }
        if let sizeCache { return sizeCache }
        func makePrototypeCell(with size: CGSize) -> UICollectionViewCell {
            // 这个临时cell可以缓存起来
            let cell = cellClass.init(frame: CGRect(origin: .zero, size: size))
            prepareLayoutSizeFitting(cell, at: indexPath)
            return cell
        }
        
        var layoutSize: CGSize = .zero
        if preferredLayoutSizeFitting == .vertical {
            // height 是预设一个大值，避免约束冲突
            let estimatedSize = CGSize(width: size.width, height: collectionView.bounds.height)
            let cell = makePrototypeCell(with: estimatedSize)
            layoutSize = cell.systemLayoutSizeFitting(estimatedSize,
                                                      withHorizontalFittingPriority: .required,
                                                      verticalFittingPriority: .fittingSizeLevel)
        } else {
            let estimatedSize = CGSize(width: collectionView.bounds.width, height: size.height)
            let cell = makePrototypeCell(with: estimatedSize)
            layoutSize = cell.systemLayoutSizeFitting(estimatedSize,
                                                      withHorizontalFittingPriority: .fittingSizeLevel,
                                                      verticalFittingPriority: .required)
        }
        return [
            max(size.width, layoutSize.width),
            max(size.height, layoutSize.height)
        ]
    }
    
    /// 撑满父视图的计算
    func collectionView(_ collectionView: UICollectionView, preferredLayoutSizeFixedAt indexPath: IndexPath) -> CGSize {
        if preferredLayoutSizeFixed == .none { return size }
        guard let parent else { return size }
        let bounds = collectionView.bounds
        let insets = parent.insets
        if preferredLayoutSizeFixed == .horizontal {
            size.width = bounds.width - insets.left - insets.right
        } else {
            size.height = bounds.height - insets.top - insets.bottom
        }
        return size
    }
}
