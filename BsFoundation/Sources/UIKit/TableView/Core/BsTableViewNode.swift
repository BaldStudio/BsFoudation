//
//  BsTableViewNode.swift
//  BsFoundation
//
//  Created by changrunze on 2023/8/18.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

// MARK: - Property

/// 逻辑基类
open class BsTableViewNode: NSObject {
    public typealias Parent = BsTableViewSection

    var cellClass: UITableViewCell.Type { UITableViewCell.self }
    
    open internal(set) weak var parent: Parent? = nil
    
    open var nib: UINib? = nil
    
    /// 指定cell的固定高度，在使用自适应高度时，则为最小高度
    open var cellHeight: CGFloat = 44

    /// 自动计算尺寸的缓存
    private var layoutSizeFittingCache = UIView.noIntrinsicMetric

    /// 自适应尺寸，设置 vertical 自适应高度
    open var preferredLayoutSizeFitting: LayoutSizeFitting = .none

    /// 是否在视图纵轴方向撑满父视图，计算结果会改变 cellHeight
    open var preferredFixedAxisSize: FixedAxisSize = .none

    // whatever but nonzero
    var estimatedRowHeight: CGFloat = 44

    /// 自适应高度的计算方式，，默认为系统计算，即 cellHeight 为 automaticDimension
    /// 如果需要预先计算高度或是需要获取内容最终高度的情况下，可以设置为 program
    /// 此时调用 prepareLayoutSizeFitting 方法即可满足需求
    /// !!!: program的情况下，目前是忽略 cell 的 Accessory View，如有必要，可以在子类中按需实现
    open var preferredLayoutStyle: LayoutStyle = .auto

    /// 选中cell的回调闭包
    open var onSelectRow: BlockT<IndexPath>?
    
    /// 默认选中后立刻反选（调用 deselectRow 实现），展示类似按钮点击高亮的状态，这会影响 tableView 的 selection 相关逻辑
    open var isSelectionAnimated = true
    
    deinit {
        logger.debug("\(self.classForCoder) -> deinit 🔥")
    }

    public override init() {
        super.init()
    }

    open var reuseIdentifier: String {
        "\(Self.self).\(cellClass).Cell"
    }
    
    open var tableView: BsTableView? {
        parent?.tableView
    }
    
    open var cell: UITableViewCell? {
        guard let indexPath = indexPath,
              let tableView = tableView else {
            return nil
        }
        
        return tableView.cellForRow(at: indexPath)
    }
    
    open var indexPath: IndexPath? {
        guard let parent = parent,
              let section = parent.index,
              let row = parent.children.firstIndex(of: self) else {
            return nil
        }
        
        return IndexPath(row: row, section: section)
    }
    
    open func reload(with animation: UITableView.RowAnimation = .none) {
        guard let tableView = tableView, let indexPath = indexPath else { return }
        tableView.reloadRows(at: [indexPath], with: animation)
    }
    
    open func invalidateCellSize() {
        layoutSizeFittingCache = UIView.noIntrinsicMetric
    }

    // MARK: - Additions
    
    open func removeFromParent() {
        parent?.remove(self)
    }
    
    // MARK: -  Cell
    
    func prepareLayoutSizeFitting(_ cell: UITableViewCell, at indexPath: IndexPath) -> CGFloat {
        // TODO: 以下计算可以使用，但还需要完善，处理 Accessory View 相关的逻辑
        let widthConstraint = cell.contentView.widthAnchor.constraint(equalToConstant: cell.bounds.width)
        widthConstraint.priority = .required - 1 // 避免约束冲突
        widthConstraint.isActive = true
        let layoutSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        layoutSizeFittingCache = max(cellHeight, layoutSize.height)
        return layoutSizeFittingCache
    }
    
    func tableView(_ tableView: BsTableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.registerCellIfNeeded(self)
        return tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                             for: indexPath)
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView,
                   didEndDisplaying cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
    }
    
    open func tableView(_ tableView: UITableView,
                        didSelectRowAt indexPath: IndexPath) {
        if isSelectionAnimated {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        onSelectRow?(indexPath)
    }
}

// MARK: - Layout Fitting

private var EPSILON: CGFloat = 1e-2

extension BsTableViewNode {
    /// 自适应尺寸计算
    func tableView(_ tableView: UITableView, preferredLayoutSizeFittingAt indexPath: IndexPath) -> CGFloat {
        if preferredLayoutSizeFitting == .none || preferredLayoutSizeFitting == .horizontal { return cellHeight }
        if preferredLayoutStyle == .auto { return UITableView.automaticDimension }
        guard EPSILON > abs(layoutSizeFittingCache - UIView.noIntrinsicMetric) else { return layoutSizeFittingCache }
        let cell = cellClass.init(style: .default, reuseIdentifier: reuseIdentifier)
        return prepareLayoutSizeFitting(cell, at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, preferredFixedAxisSizeAt indexPath: IndexPath) -> CGFloat {
        if preferredFixedAxisSize == .none || preferredFixedAxisSize == .horizontal { return cellHeight }
        cellHeight = tableView.bounds.height - tableView.adjustedContentInset.top
        return cellHeight
    }
}
