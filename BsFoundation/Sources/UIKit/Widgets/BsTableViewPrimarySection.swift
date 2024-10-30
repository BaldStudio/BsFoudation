//
//  BsTableViewPrimarySection.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/10/30.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

public extension BsTableViewPrimarySection {
    static let preferredHeight: CGFloat = 36
}

open class BsTableViewPrimarySection: BsTableViewSection {
    open var headerTitle: String? {
        didSet {
            if let title = headerTitle, title.isNotEmpty {
                preferredHeaderLayoutSizeFitting = .vertical
            } else {
                preferredHeaderLayoutSizeFitting = .none
            }
        }
    }
    
    public override init() {
        super.init()
        headerClass = BsTableViewPrimarySectionHeader.self
        headerHeight = Self.preferredHeight
        preferredHeaderLayoutSizeFitting = .vertical
        
        footerHeight = .leastNormalMagnitude
    }
    
    public convenience init(headerTitle: String) {
        self.init()
        self.headerTitle = headerTitle
    }
    
    open override func update(header: UITableViewHeaderFooterView, in section: Int) {
        guard let header = header as? BsTableViewPrimarySectionHeader else { return }
        header.titleLabel.text = headerTitle
    }
}

open class BsTableViewPrimarySectionHeader: BsUITableViewHeaderFooterView {
    let titleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = UIColor(0x666666)
    }

    open override func onInit() {
        super.onInit()
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
}

