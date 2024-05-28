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
    
    open var tableView: BsTableView? { parent?.tableView }

    open var nib: UINib? = nil
    
    /// 指定 cell 的固定高度，在使用自适应高度时，则为最小高度
    open var height: CGFloat = 44
    
    // whatever but nonzero
    var estimatedHeight: CGFloat = 44

    /// 自动计算尺寸的缓存
    var heightCache: CGFloat? = nil
    
    /// 自适应尺寸，设置 vertical 自适应高度
    open var preferredLayoutSizeFitting: LayoutSizeFitting = .none

    /// 是否在视图纵轴方向撑满父视图，计算结果会改变 height
    open var preferredLayoutSizeFixed: LayoutSizeFixed = .none

    /// 自适应高度的计算方式，默认为系统计算，即 rowHeight 为 automaticDimension
    /// 如果需要预先计算高度或是需要获取内容最终高度的情况下，可以设置为 manual
    /// 此时调用 prepareLayoutSizeFitting 方法即可满足需求
    /// !!!: manual的情况下，目前是忽略 cell 的 Accessory View，如有必要，可以在子类中按需实现
    open var preferredLayoutMode: LayoutMode = .auto

    /// 选中cell的回调闭包
    open var onSelectRow: BlockT<IndexPath>?
    
    /// 默认选中后立刻反选（调用 deselectRow 实现），展示类似按钮点击高亮的状态，这会影响 tableView 的 selection 相关逻辑
    open var isSelectionAnimated = true
    
    deinit {
        logger.debug("\(classForCoder) -> deinit 🔥")
    }

    public override init() {
        super.init()
    }

    open var reuseIdentifier: String {
        "\(Self.self).\(cellClass).Cell"
    }
        
    open var cell: UITableViewCell? {
        guard let indexPath, let tableView else {
            return nil
        }
        
        return tableView.cellForRow(at: indexPath)
    }
    
    open var indexPath: IndexPath? {
        guard let parent,
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
    
    open func invalidateHeight() {
        heightCache = nil
    }

    // MARK: - Additions
    
    open func removeFromParent() {
        parent?.remove(self)
    }
    
    // MARK: -  Cell
    
    func prepareLayoutSizeFitting(_ cell: UITableViewCell, at indexPath: IndexPath) -> CGFloat {
        // TODO: 以下计算可以使用，但还需要完善，比如需要处理 Accessory View 相关的逻辑
        let widthConstraint = cell.contentView.widthAnchor.constraint(equalToConstant: cell.bounds.width)
        widthConstraint.priority = .required - 1 // 避免约束冲突
        widthConstraint.isActive = true
        let layoutSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return max(height, layoutSize.height)
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

extension BsTableViewNode {
    /// 自适应尺寸计算
    func tableView(_ tableView: UITableView, preferredLayoutSizeFittingAt indexPath: IndexPath) -> CGFloat {
        if preferredLayoutMode == .auto { return UITableView.automaticDimension }
        if preferredLayoutSizeFitting == .none || preferredLayoutSizeFitting == .horizontal { return height }
        let cell = cellClass.init(style: .default, reuseIdentifier: reuseIdentifier)
        return prepareLayoutSizeFitting(cell, at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, preferredLayoutSizeFixedAt indexPath: IndexPath) -> CGFloat {
        if preferredLayoutSizeFixed == .none || preferredLayoutSizeFixed == .horizontal { return height }
        height = tableView.bounds.height - tableView.adjustedContentInset.top
        return height
    }    
}
