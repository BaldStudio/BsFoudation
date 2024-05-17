//
//  BsApp.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/16.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

public enum BsApp {
    static let shared = UIApplication.shared
        
    static let id = Bundle.main.info(for: .id)
    static let name = Bundle.main.info(for: .displayName)
    static let version = Bundle.main.info(for: .version)
    
    static var isTestFlight: Bool {
        guard let appStoreReceiptURL = Bundle.main.appStoreReceiptURL else {
            return false
        }
        return appStoreReceiptURL.lastPathComponent == "sandboxReceipt"
    }
}

public extension BsApp {
    // TODO:
    static let keyWindow: UIWindow? = nil
    
    static let mainWindow: UIWindow? = nil
}
