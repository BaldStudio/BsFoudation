//
//  Toast.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/29.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

// TODO: 继续干

public class Toast: BsUIView {
    
}

public extension Toast {
    class BackgroundView: BsUIView {
        private let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThickMaterialDark))
        
        var blurStyle: UIBlurEffect.Style = .systemThickMaterialDark {
            didSet {
                effectView.effect = UIBlurEffect(style: blurStyle)
            }
        }

        public override func onInit() {
            super.onInit()
            clipsToBounds = true
            
            addSubview(effectView)
            effectView.edgesEqualToSuperview()
        }
        
    }
}
