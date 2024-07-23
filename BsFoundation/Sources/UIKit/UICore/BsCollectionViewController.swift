//
//  BsCollectionViewController.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/16.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

open class BsCollectionViewController: BsViewController, UICollectionViewDelegate {
    open lazy var section = BsCollectionViewSection().then {
        collectionView.insert($0, at: 0)
    }
    
    public convenience init(layout: UICollectionViewLayout) {
        self.init(nibName: nil, bundle: nil)
        collectionView = BsCollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        
    }

    @NullResetable
    open var collectionView: BsCollectionView! = BsCollectionView(delegate: nil)
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewWillMoveToSuperview()
    }

    open func collectionViewWillMoveToSuperview() {
        view.addSubview(collectionView)
        collectionView.edgesEqualToSuperview()
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
    }
}

private extension BsCollectionViewController {
    static func initCollectionView() -> BsCollectionView {
        BsCollectionView(delegate: nil)
    }
}
