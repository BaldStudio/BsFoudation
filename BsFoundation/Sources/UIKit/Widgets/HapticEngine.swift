//
//  HapticEngine.swift
//  BsFoundation
//
//  Created by crzorz on 2021/9/2.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import UIKit

public struct HapticEngine {
    static func driven(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let gen = UIImpactFeedbackGenerator(style: style)
        gen.prepare()
        gen.impactOccurred()
    }
}

