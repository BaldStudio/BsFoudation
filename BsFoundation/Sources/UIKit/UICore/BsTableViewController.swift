//
//  BsTableViewController.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/16.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

open class BsTableViewController: BsViewController, UITableViewDelegate {
    public convenience init(style: UITableView.Style) {
        self.init(nibName: nil, bundle: nil)
        tableView = BsTableView(frame: .zero, style: style)
    }

    @NullResetable
    open var tableView: BsTableView! = BsTableView(delegate: nil)

    open override func viewDidLoad() {
        super.viewDidLoad()
        tableViewWillMoveToSuperview()
    }

    open func tableViewWillMoveToSuperview() {
        view.addSubview(tableView)
        tableView.edgesEqualToSuperview()
        tableView.delegate = self
        tableView.tableFooterView = BsSafeInsetsView()
    }
}

