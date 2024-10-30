//
//  BsTableViewRow.swift
//  BsFoundation
//
//  Created by changrunze on 2023/6/7.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

public protocol BsTableViewRowRepresentable: AnyObject, CustomStringConvertible {}

extension BsTableViewRowRepresentable {
    var inner: _BsTableViewRowRepresentable {
        self as! _BsTableViewRowRepresentable
    }
}

protocol _BsTableViewRowRepresentable: BsTableViewRowRepresentable {
    var parent: BsTableViewSection? { get set }
    
    var cellClass: UITableViewCell.Type { get }
    
    var nib: UINib? { get }
    
    var reuseIdentifier: String { get }
    
    var estimatedHeight: CGFloat { get }
    
    var heightCache: CGFloat? { get set }
    
    func removeFromParent()

    func tableView(_ tableView: BsTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell

    func tableView(_ tableView: BsTableView, didSelectRowAt indexPath: IndexPath)

    func tableView(_ tableView: UITableView, preferredLayoutSizeFittingAt indexPath: IndexPath) -> CGFloat
    
    func tableView(_ tableView: UITableView, preferredLayoutSizeFixedAt indexPath: IndexPath) -> CGFloat

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath)
}

// MARK: - Property

open class BsTableViewRow<CellType: UITableViewCell>: NSObject, _BsTableViewRowRepresentable {
    var cellClass: UITableViewCell.Type { CellType.self }
    var nib: UINib? = nil
    
    open internal(set) weak var parent: BsTableViewSection? = nil
    
    open var tableView: BsTableView? { parent?.tableView }

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
    open var onDidSelect: BlockT<IndexPath>?
    
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
    
    open var cell: CellType? {
        guard let indexPath, let tableView else {
            return nil
        }
        
        return tableView.cellForRow(at: indexPath) as? CellType
    }
    
    open var indexPath: IndexPath? {
        guard let parent,
              let section = parent.section,
              let row = parent.index(of: self) else {
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
    
    open func removeFromParent() {
        parent?.remove(self)
    }

    // MARK: -  Cell
    
    open func tableView(_ tableView: BsTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.registerCellIfNeeded(self)
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        if let cell = cell as? CellType {
            update(cell, at: indexPath)
        }
        return cell
    }
    
    open func update(_ cell: CellType, at indexPath: IndexPath) {}
    
    open func tableView(_ tableView: BsTableView, didSelectRowAt indexPath: IndexPath) {
        if isSelectionAnimated {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        onDidSelect?(indexPath)
    }
    
    open func willDisplay(_ cell: CellType, at indexPath: IndexPath) {}
    open func didEndDisplaying(_ cell: CellType, at indexPath: IndexPath) {}
}

extension BsTableViewRow {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? CellType else { return }
        willDisplay(cell, at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? CellType else { return }
        didEndDisplaying(cell, at: indexPath)
    }
}

// MARK: - Layout Fitting

extension BsTableViewRow {
    func prepareLayoutSizeFitting(_ cell: UITableViewCell, at indexPath: IndexPath) -> CGFloat {
        // 触发 cell 的更新，填充数据以便计算尺寸
        if let cell = cell as? CellType {
            update(cell, at: indexPath)
        } else {
            assertionFailure("cell as? \(CellType.self) failed")
        }
        
        // TODO: 以下计算可以使用，但还需要完善，比如需要处理 Accessory View 相关的逻辑
        let widthConstraint = cell.contentView.widthAnchor.constraint(equalToConstant: cell.bounds.width)
        widthConstraint.priority = .required - 1 // 避免约束冲突
        widthConstraint.isActive = true
        let layoutSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return max(height, layoutSize.height)
    }

    /// 自适应尺寸计算
    func tableView(_ tableView: UITableView, preferredLayoutSizeFittingAt indexPath: IndexPath) -> CGFloat {
        if preferredLayoutMode == .auto { return UITableView.automaticDimension }
        if preferredLayoutSizeFixed != .vertical { return height }
        let cell = cellClass.init(style: .default, reuseIdentifier: reuseIdentifier)
        return prepareLayoutSizeFitting(cell, at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, preferredLayoutSizeFixedAt indexPath: IndexPath) -> CGFloat {
        if preferredLayoutSizeFixed != .vertical { return height }
        height = tableView.bounds.height - tableView.adjustedContentInset.top
        return height
    }
}

// MARK: - Mutable Cell Class

open class BsTableViewMutableRow: BsTableViewRow<UITableViewCell> {
    private var _cellClass: UITableViewCell.Type = UITableViewCell.self
    
    open override var cellClass: UITableViewCell.Type {
        set { _cellClass = newValue }
        get { _cellClass }
    }
}

// MARK: -  Extensions

public extension BsTableViewRow {
    var viewController: UIViewController? {
        tableView?.viewController
    }
    
    var navigationController: UINavigationController? {
        tableView?.navigationController
    }
}
