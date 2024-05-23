//
//  BsCollectionViewNode+.swift
//  BsFoundation
//
//  Created by changrunze on 2023/10/30.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

public extension BsCollectionViewNode {
    var viewController: UIViewController? {
        collectionView?.viewController
    }
    
    var navigationController: UINavigationController? {
        collectionView?.navigationController
    }
}
