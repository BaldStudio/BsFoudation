//
//  BsTableViewRow.swift
//  BsFoundation
//
//  Created by changrunze on 2023/6/7.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

// MARK: - Property

open class BsTableViewRow<T: UITableViewCell>: BsTableViewNode {
    override var cellClass: UITableViewCell.Type {
        T.self
    }
                
    public override func prepareLayoutSizeFitting(_ cell: UITableViewCell, at indexPath: IndexPath) -> CGFloat {
        guard let cell = cell as? T else { return 0 }
        update(cell, at: indexPath)
        return super.prepareLayoutSizeFitting(_: cell, at: indexPath)
    }
    
    override func tableView(_ tableView: BsTableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let cell = cell as? T {
            update(cell, at: indexPath)
        }
        return cell
    }
    
    open func update(_ cell: T, at indexPath: IndexPath) {}

    override func tableView(_ tableView: UITableView,
                            willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        guard let cell = cell as? T else { return }
        willDisplay(cell, at: indexPath)
    }
    
    open func willDisplay(_ cell: T, at indexPath: IndexPath) {}

    override func tableView(_ tableView: UITableView,
                            didEndDisplaying cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        guard let cell = cell as? T else { return }
        didEndDisplaying(cell, at: indexPath)
    }
    
    open func didEndDisplaying(_ cell: T, at indexPath: IndexPath) {}
}

// MARK: - Mutable Cell Class

open class BsTableViewMutableRow: BsTableViewRow<UITableViewCell> {

    private var _cellClass: UITableViewCell.Type = UITableViewCell.self
    
    open override var cellClass: UITableViewCell.Type {
        set { _cellClass = newValue }
        get { _cellClass }
    }
    
}
