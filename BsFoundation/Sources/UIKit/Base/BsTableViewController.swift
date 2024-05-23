//
//  BsTableViewController.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/16.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

open class BsTableViewController: BsViewController, UITableViewDelegate {
    open lazy var section = BsTableViewSection().then {
        tableView.insert($0, at: 0)
    }
    
    public convenience init(style: UITableView.Style) {
        self.init(nibName: nil, bundle: nil)
        tableView = BsTableView(frame: .zero, style: style)
    }

    @NullResetable(body: initTableView)
    open var tableView: BsTableView!

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

private extension BsTableViewController {
    static func initTableView() -> BsTableView {
        BsTableView(delegate: nil)
    }
}

