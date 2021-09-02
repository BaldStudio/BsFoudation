//
//  TableView+Row.swift
//  BsFoundation
//
//  Created by crzorz on 2021/7/8.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import UIKit

extension TableView {
    open class Row {
        public weak internal(set) var parent: Section? = nil
        
        public init() {}
        
        open var cellHeight: CGFloat = 44.0
        
        open var autofitCellHeight = false

        open var cellClass: AnyClass = UITableViewCell.self

        open func invalidateCellHeight() {
            cellHeight = 0.0
        }

        open var reuseIdentifier: String {
            "\(Self.self)\(cellClass)"
        }
        
        public var indexPath: IndexPath? {
            guard let s = parent,
                let si = s.index,
                let r = parent?.children.firstIndex(of: self) else {
                return nil
            }
            return IndexPath(row: r, section: si)
        }
        
        open func reload(with animation: RowAnimation = .none) {
            guard let tableView = parent?.parent?.parent, let i = indexPath else { return }
            tableView.reloadRows(at: [i], with: animation)
        }
        
        open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
            if let updateCell = updateCell {
                cell = updateCell(cell, indexPath)
            }
            return cell
        }
        
        open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            willDisplayCell?(cell, indexPath)
        }
        
        open func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            didEndDisplayingCell?(cell, indexPath)
        }
        
        open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            didSelectRow?(indexPath)
        }
        
        //MARK: - Closure
        
        public var updateCell: ((UITableViewCell, IndexPath) -> UITableViewCell)?
        public var didSelectRow: ((IndexPath) -> Void)?
        public var willDisplayCell: ((UITableViewCell, IndexPath) -> Void)?
        public var didEndDisplayingCell: ((UITableViewCell, IndexPath) -> Void)?

    }
}

extension TableView.Row: Equality {
    
    func tableView(_ tableView: TableView, autofitCellHeightAt indexPath: IndexPath) -> CGFloat {
        if (cellHeight > 0) {
            return cellHeight
        }
        
        let cell = tableView.rootNode.tableView(tableView, cellForRowAt: indexPath)
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        cellHeight = cell.contentView.systemLayoutSizeFitting(fittingSize).height + 1.0
        return cellHeight;
    }

}
