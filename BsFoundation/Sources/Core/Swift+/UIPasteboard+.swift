//
//  UIPasteboard+.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/17.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

public extension UIPasteboard {
    static func copy(text: String) {
        UIPasteboard.general.string = text
    }
    
    static func pasted() -> String {
        guard let pasteboard = UIPasteboard.general.string else {
            return .empty
        }
        return pasteboard
    }
}
