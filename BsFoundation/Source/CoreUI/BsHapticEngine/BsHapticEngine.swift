//
//  BsHapticEngine.swift
//  BsFoundation
//
//  Created by crzorz on 2021/9/2.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import UIKit

public struct BsHapticEngine {
    typealias FeedbackGenerator = UIImpactFeedbackGenerator
    var generatorsByLevel: [Level: FeedbackGenerator] = [:]
    
    public static let shared =  BsHapticEngine()
    
    init() {
        for lv in Level.all {
            generatorsByLevel[lv] = UIImpactFeedbackGenerator(style: lv.toSystemValue())
        }
    }
    
    public static func feedback(_ lv: Level) {
        guard let gen = shared.generatorsByLevel[lv] else {
            return
        }
        
        gen.prepare()
        gen.impactOccurred()
    }
}

public extension BsHapticEngine {
    enum Level: Int {
        case light
        case medium
        case heavy
        
        fileprivate static let all: [Self] = [.light, .medium, .heavy]
        fileprivate func toSystemValue() -> UIImpactFeedbackGenerator.FeedbackStyle {
            UIImpactFeedbackGenerator.FeedbackStyle(rawValue: rawValue)!
        }
    }
}
