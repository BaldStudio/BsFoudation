//
//  BsTableViewSection+.swift
//  BsFoundation
//
//  Created by 常润泽 on 2024/2/23.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

public extension BsTableViewSection {
    var viewController: UIViewController? {
        tableView?.viewController
    }
    
    var navigationController: UINavigationController? {
        tableView?.navigationController
    }
}
