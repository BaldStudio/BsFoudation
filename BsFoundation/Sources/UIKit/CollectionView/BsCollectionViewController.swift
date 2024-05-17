//
//  BsCollectionViewController.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/16.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

open class BsCollectionViewController: BsUIViewController, UICollectionViewDelegate {
    public lazy var section = BsCollectionViewSection().then {
        collectionView.bs.dataSource.insert($0, at: 0)
    }
    
    public convenience init(layout: UICollectionViewLayout) {
        self.init(nibName: nil, bundle: nil)
        collectionView = BsCollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        
    }

    @NullResetable(body: initCollectionView)
    open var collectionView: BsCollectionView!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionViewDidMoveToSuperview()
    }

    open func collectionViewDidMoveToSuperview() {
        view.addSubview(collectionView)
        collectionView.edgesEqualToSuperview()
    }
}

private extension BsCollectionViewController {
    static func initCollectionView() -> BsCollectionView {
        BsCollectionView(delegate: nil)
    }
}
