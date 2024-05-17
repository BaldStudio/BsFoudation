//
//  BsTableViewNode+.swift
//  BsFoundation
//
//  Created by changrunze on 2023/10/30.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

public extension BsTableViewNode {
    var viewController: UIViewController? {
        tableView?.viewController
    }
    
    var navigationController: UINavigationController? {
        tableView?.navigationController
    }
}
