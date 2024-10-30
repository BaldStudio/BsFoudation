//
//  BsCollectionViewItem.swift
//  BsFoundation
//
//  Created by changrunze on 2023/6/30.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

public protocol BsCollectionViewItemRepresentable: AnyObject, CustomStringConvertible {}

extension BsCollectionViewItemRepresentable {
    var inner: _BsCollectionViewItemRepresentable {
        self as! _BsCollectionViewItemRepresentable
    }
}

protocol _BsCollectionViewItemRepresentable: BsCollectionViewItemRepresentable {
    var parent: BsCollectionViewSection? { get set }

    var cellClass: UICollectionViewCell.Type { get }
    
    var nib: UINib? { get }
    
    var reuseIdentifier: String { get }
    
    var sizeCache: CGSize? { get set }
    
    func removeFromParent()

    func collectionView(_ collectionView: BsCollectionView,     
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    
    func collectionView(_ collectionView: BsCollectionView, didSelectItemAt indexPath: IndexPath)
    
    func collectionView(_ collectionView: BsCollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath)
    
    func collectionView(_ collectionView: BsCollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath)
    
    func collectionView(_ collectionView: BsCollectionView, didHighlightItemAt indexPath: IndexPath)
    func collectionView(_ collectionView: BsCollectionView, didUnhighlightItemAt indexPath: IndexPath)
    
    func collectionView(_ collectionView: BsCollectionView, preferredLayoutSizeFixedAt indexPath: IndexPath) -> CGSize
    func collectionView(_ collectionView: BsCollectionView, preferredLayoutSizeFittingAt indexPath: IndexPath) -> CGSize
}

// MARK: - Property

open class BsCollectionViewItem<CellType: UICollectionViewCell>: NSObject, _BsCollectionViewItemRepresentable {
    var cellClass: UICollectionViewCell.Type { CellType.self }
    var nib: UINib? = nil

    open internal(set) weak var parent: BsCollectionViewSection? = nil
    
    open var collectionView: BsCollectionView? { parent?.collectionView }

    /// 指定 cell 的固定尺寸，在自适应尺寸时，则为自动计算方向上的最小值
    open var size: CGSize = .zero
    
    /// 自动计算尺寸的缓存
    var sizeCache: CGSize? = nil

    /// 是否自动计算尺寸，vertical会自动算高，horizontal会自动算宽
    open var preferredLayoutSizeFitting: LayoutSizeFitting = .none
    
    /// 是否在视图主轴或纵轴方向撑满父视图，计算结果会改变 cellSize
    open var preferredLayoutSizeFixed: LayoutSizeFixed = .none

    /// 选中cell的回调闭包
    open var onDidSelect: BlockT<IndexPath>?

    deinit {
        logger.debug("\(classForCoder) -> deinit 🔥")
    }

    public override init() {
        super.init()
    }

    open var reuseIdentifier: String {
        "\(Self.self).\(cellClass).Cell"
    }
        
    open var cell: CellType? {
        guard let collectionView, let indexPath else { return nil }
        return collectionView.cellForItem(at: indexPath) as? CellType
    }

    open var indexPath: IndexPath? {
        guard let parent = parent,
              let section = parent.section,
              let item = parent.index(of: self) else {
            return nil
        }
        return IndexPath(row: item, section: section)
    }
    
    open func reload() {
        guard let collectionView, let indexPath else { return }
        collectionView.reloadItems(at: [indexPath])
    }
    
    /// 重置cell的高度 会重新执行计算逻辑
    open func invalidateSize() {
        sizeCache = nil
    }

    open func removeFromParent() {
        parent?.remove(self)
    }
    
    // MARK: - Cell
        
    open func prepareLayoutSizeFitting(at indexPath: IndexPath) -> CGSize {
        guard let collectionView else { return size }
        
        let horizontalFittingPriority: UILayoutPriority
        let verticalFittingPriority: UILayoutPriority
        let estimatedSize: CGSize
        
        if preferredLayoutSizeFitting == .vertical {
            horizontalFittingPriority = .required
            verticalFittingPriority = .fittingSizeLevel
            estimatedSize = CGSize(width: size.width, height: collectionView.bounds.height)
        } else {
            horizontalFittingPriority = .fittingSizeLevel
            verticalFittingPriority = .required
            estimatedSize = CGSize(width: collectionView.bounds.width, height: size.height)
        }
        
        let cell = cellClass.init(frame: CGRect(origin: .zero, size: estimatedSize))
        if let cell = cell as? CellType {
            cellForItem(cell, at: indexPath)
        } else {
            assertionFailure("cell as? \(CellType.self) failed")
        }
        return cell.systemLayoutSizeFitting(estimatedSize,
                                            withHorizontalFittingPriority: horizontalFittingPriority,
                                            verticalFittingPriority: verticalFittingPriority)
    }
    
    open func collectionView(_ collectionView: BsCollectionView, didSelectItemAt indexPath: IndexPath) {
        onDidSelect?(indexPath)
    }
    
    open func collectionView(_ collectionView: BsCollectionView, didHighlightItemAt indexPath: IndexPath) {}
    open func collectionView(_ collectionView: BsCollectionView, didUnhighlightItemAt indexPath: IndexPath) {}


    open func cellForItem(_ cell: CellType, at indexPath: IndexPath) {}
    open func willDisplay(_ cell: CellType, at indexPath: IndexPath) {}
    open func didEndDisplaying(_ cell: CellType, at indexPath: IndexPath) {}
}

// MARK: -  Cell Delegate

extension BsCollectionViewItem {
    func collectionView(_ collectionView: BsCollectionView,
                             cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.registerCellIfNeeded(self)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if let cell = cell as? CellType {
            cellForItem(cell, at: indexPath)
        }
        return cell
    }
    
    func collectionView(_ collectionView: BsCollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard let cell = cell as? CellType else { return }
        willDisplay(cell, at: indexPath)
    }
    
    func collectionView(_ collectionView: BsCollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard let cell = cell as? CellType else { return }
        willDisplay(cell, at: indexPath)
    }
}

// MARK: - Layout Fitting

extension BsCollectionViewItem {
    /// 撑满父视图的计算
    func collectionView(_ collectionView: BsCollectionView, preferredLayoutSizeFixedAt indexPath: IndexPath) -> CGSize {
        if preferredLayoutSizeFixed == .none { return size }
        guard let parent else { return size }
        let insets = parent.insets
        if preferredLayoutSizeFixed == .horizontal {
            size.width = collectionView.bounds.width - insets.left - insets.right
        } else {
            size.height = collectionView.bounds.height - insets.top - insets.bottom
        }
        return size
    }

    /// 自适应尺寸计算，如果计算不正确，请检查约束是否符合计算条件
    func collectionView(_ collectionView: BsCollectionView, preferredLayoutSizeFittingAt indexPath: IndexPath) -> CGSize {
        if preferredLayoutSizeFitting == .none { return size }
        let layoutSize = prepareLayoutSizeFitting(at: indexPath)
        return [
            max(size.width, layoutSize.width),
            max(size.height, layoutSize.height)
        ]
    }
}

// MARK: - Mutable Cell Class

open class BsCollectionViewMutableItem: BsCollectionViewItem<UICollectionViewCell> {
    private struct Metadata {
        var cellClass: UICollectionViewCell.Type = UICollectionViewCell.self
    }
    
    private var metadata = Metadata()
    
    open override var cellClass: UICollectionViewCell.Type {
        set { metadata.cellClass = newValue }
        get { metadata.cellClass }
    }
}

// MARK: -  Utils

public extension BsCollectionViewItem {
    var viewController: UIViewController? {
        collectionView?.viewController
    }
    
    var navigationController: UINavigationController? {
        collectionView?.navigationController
    }
}

