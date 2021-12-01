//
//  Recommend.swift
//  BsStoreKit
//
//  Created by crzorz on 2021/8/27.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import StoreKit

public struct Recommend {
    
    public static func fetch(with appid: String) {
        let url = URL(string: "itms-apps://itunes.apple.com/app/id\(appid)?action=write-review")!
        guard UIApplication.shared.canOpenURL(url) else {
            return
        }
        
        UIApplication.shared.open(url,
                                  options: [:],
                                  completionHandler: nil)
    }
    
    public static func requestReview() {
        SKStoreReviewController.requestReview()
    }
}
