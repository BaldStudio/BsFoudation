//
//  BsCollectionViewProxy.swift
//  BsFoundation
//
//  Created by changrunze on 2023/6/30.
//  Copyright © 2023 BaldStudio. All rights reserved.
//

// MARK: - Property

final class BsCollectionViewProxy: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private lazy var impl = BsCollectionViewProxyImpl(self)

    @NullResetable
    var dataSource: BsCollectionViewDataSource! = BsCollectionViewDataSource()
    
    weak var collectionView: BsCollectionView! {
        didSet {
            dataSource.parent = collectionView
        }
    }
    
    weak var target: UICollectionViewDelegate?
    
    deinit {
        logger.debug("\(classForCoder) -> deinit 🔥")
    }
        
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        (target?.responds(to: aSelector) == true ? target : impl) ?? super.forwardingTarget(for: aSelector)
    }
        
    override func responds(to aSelector: Selector!) -> Bool {
        target?.responds(to: aSelector) == true || impl.responds(to: aSelector) == true || super.responds(to: aSelector)
    }
}

// MARK: - Delegate Impl

private class BsCollectionViewProxyImpl: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    weak var proxy: BsCollectionViewProxy!
    
    var dataSource: BsCollectionViewDataSource { proxy.dataSource }
    
    deinit {
        logger.debug("\(classForCoder) -> deinit 🔥")
    }
    
    convenience init(_ proxy: BsCollectionViewProxy) {
        self.init()
        self.proxy = proxy
    }
}

// MARK: - Cell

extension BsCollectionViewProxyImpl {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dataSource[indexPath]?.inner.collectionView(proxy.collectionView, didSelectItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        dataSource[indexPath]?.inner.collectionView(proxy.collectionView, didHighlightItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        dataSource[indexPath]?.inner.collectionView(proxy.collectionView, didUnhighlightItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        dataSource[indexPath]?.inner.collectionView(proxy.collectionView, willDisplay: cell, forItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        // 数据源发生变化，执行remove时，会先触发这里，需要处理数组越界问题
        // 此时外部 Item 对象不再触发该方法，如有特殊需要，可在其他类（如ViewController）实现该代理方法执行逻辑
        dataSource[indexPath]?.inner.collectionView(proxy.collectionView, didEndDisplaying: cell, forItemAt: indexPath)
    }
}

// MARK: - Supplementary View

extension BsCollectionViewProxyImpl {
    func collectionView(_ collectionView: UICollectionView,
                        willDisplaySupplementaryView view: UICollectionReusableView,
                        forElementKind elementKind: String,
                        at indexPath: IndexPath) {
        let sect = dataSource[indexPath.section]
        if elementKind == UICollectionView.elementKindSectionHeader {
            sect?.willDisplay(header: view, at: indexPath)
        } else if elementKind == UICollectionView.elementKindSectionFooter {
            sect?.willDisplay(footer: view, at: indexPath)
        } else {
            sect?.collectionView(proxy.collectionView,
                                willDisplaySupplementaryView: view,
                                forElementKind: elementKind,
                                at: indexPath)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplayingSupplementaryView view: UICollectionReusableView,
                        forElementOfKind elementKind: String, at indexPath: IndexPath) {
        // 数据源发生变化，执行remove时，会先触发这里，需要处理数组越界问题
        // 此时外部 Item 对象不再触发该方法，如有特殊需要，可在其他类（如ViewController）实现该代理方法执行逻辑
        let sect = dataSource[indexPath.section]
        if elementKind == UICollectionView.elementKindSectionHeader {
            sect?.didEndDisplaying(header: view, at: indexPath)
        } else if elementKind == UICollectionView.elementKindSectionFooter {
            sect?.didEndDisplaying(footer: view, at: indexPath)
        } else {
            sect?.collectionView(proxy.collectionView,
                                 didEndDisplayingSupplementaryView: view,
                                 forElementOfKind: elementKind,
                                 at: indexPath)
        }
    }
}

// MARK: - Flow Layout

extension BsCollectionViewProxyImpl {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let item = dataSource[indexPath]?.inner else { return .zero }
        if let sizeCache = item.sizeCache { return sizeCache }
        var size = item.collectionView(proxy.collectionView, preferredLayoutSizeFixedAt: indexPath)
        size = item.collectionView(proxy.collectionView, preferredLayoutSizeFittingAt: indexPath)
        item.sizeCache = size
        return size
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        dataSource[section]?.insets ?? .zero
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        dataSource[section]?.minimumLineSpacing ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        dataSource[section]?.minimumInteritemSpacing ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        dataSource[section]?.headerSize ?? .zero
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        dataSource[section]?.footerSize ?? .zero
    }
}
