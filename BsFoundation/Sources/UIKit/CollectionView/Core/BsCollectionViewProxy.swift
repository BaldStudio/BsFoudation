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

    @NullResetable(default: BsCollectionViewDataSource())
    var dataSource: BsCollectionViewDataSource!
    
    weak var collectionView: BsCollectionView! {
        didSet {
            dataSource.parent = collectionView
        }
    }
    
    weak var target: UICollectionViewDelegate?
    
    deinit {
        logger.debug("\(self.classForCoder) -> deinit 🔥")
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
    
    deinit {
        logger.debug("\(self.classForCoder) -> deinit 🔥")
    }
    
    convenience init(_ proxy: BsCollectionViewProxy) {
        self.init()
        self.proxy = proxy
    }
}

// MARK: - Cell

extension BsCollectionViewProxyImpl {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        proxy.dataSource[indexPath].collectionView(collectionView, didSelectItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        proxy.dataSource[indexPath].collectionView(collectionView, didHighlightItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        proxy.dataSource[indexPath].collectionView(collectionView, didUnhighlightItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        proxy.dataSource[indexPath].collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        // 数据源发生变化，执行remove时，会先触发这里，需要处理数组越界问题
        // 此时外部 Item 对象不再触发该方法，如有特殊需要，可在其他类（如ViewController）实现该代理方法执行逻辑
        guard indexPath.section < proxy.dataSource.count else {
            return
        }
        let section = proxy.dataSource[indexPath.section]
        guard indexPath.item < section.count else {
            return
        }
        section[indexPath.item].collectionView(collectionView, didEndDisplaying: cell, forItemAt: indexPath)
    }
}

// MARK: - Supplementary View

extension BsCollectionViewProxyImpl {
    func collectionView(_ collectionView: UICollectionView,
                        willDisplaySupplementaryView view: UICollectionReusableView,
                        forElementKind elementKind: String,
                        at indexPath: IndexPath) {
        let element = proxy.dataSource[indexPath.section]
        if elementKind == UICollectionView.elementKindSectionHeader {
            element.willDisplay(header: view, at: indexPath)
        } else if elementKind == UICollectionView.elementKindSectionFooter {
            element.willDisplay(footer: view, at: indexPath)
        } else {
            element.collectionView(proxy.collectionView,
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
        guard indexPath.section < proxy.dataSource.count else {
            return
        }

        let element = proxy.dataSource[indexPath.section]
        if elementKind == UICollectionView.elementKindSectionHeader {
            element.didEndDisplaying(header: view, at: indexPath)
        } else if elementKind == UICollectionView.elementKindSectionFooter {
            element.didEndDisplaying(footer: view, at: indexPath)
        } else {
            element.collectionView(proxy.collectionView,
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
        let item = proxy.dataSource[indexPath]
        var size = item.collectionView(collectionView, preferredFixedAxisSizeAt: indexPath)
        size = item.collectionView(collectionView, preferredLayoutSizeFittingAt: indexPath)
        return size
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        proxy.dataSource[section].insets
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        proxy.dataSource[section].minimumLineSpacing
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        proxy.dataSource[section].minimumInteritemSpacing
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        proxy.dataSource[section].headerSize
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        proxy.dataSource[section].footerSize
    }
}
