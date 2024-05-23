//
//  BsCollectionViewItem.swift
//  BsFoundation
//
//  Created by changrunze on 2023/6/30.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

// MARK: - Property

open class BsCollectionViewItem<T: UICollectionViewCell>: BsCollectionViewNode {
    override var cellClass: UICollectionViewCell.Type {
        T.self
    }

    // MARK: - Cell
    override func prepareLayoutSizeFitting(_ cell: UICollectionViewCell, at indexPath: IndexPath) {
        guard let cell = cell as? T else { return }
        update(cell, at: indexPath)
    }

    override func collectionView(_ collectionView: BsCollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath)
        if let cell = cell as? T {
            update(cell, at: indexPath)
        }
        return cell
    }

    open func update(_ cell: T, at indexPath: IndexPath) {}

    override func collectionView(_ collectionView: UICollectionView,
                                 willDisplay cell: UICollectionViewCell,
                                 forItemAt indexPath: IndexPath) {
        guard let cell = cell as? T else { return }
        willDisplay(cell, at: indexPath)
    }
    
    open func willDisplay(_ cell: T, at indexPath: IndexPath) {}

    override func collectionView(_ collectionView: UICollectionView,
                                 didEndDisplaying cell: UICollectionViewCell,
                                 forItemAt indexPath: IndexPath) {
        guard let cell = cell as? T else { return }
        didEndDisplaying(cell, at: indexPath)
    }
    
    open func didEndDisplaying(_ cell: T, at indexPath: IndexPath) {}
}

// MARK: - Mutable Cell Class

open class BsCollectionViewMutableItem: BsCollectionViewItem<UICollectionViewCell> {
    private var _cellClass: UICollectionViewCell.Type = UICollectionViewCell.self

    open override var cellClass: UICollectionViewCell.Type {
        set { _cellClass = newValue }
        get { _cellClass }
    }
}
