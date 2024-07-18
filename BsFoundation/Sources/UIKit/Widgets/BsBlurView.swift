//
//  BsBlurView.swift
//  BsFoundation
//
//  Created by 常润泽 on 2024/3/7.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

open class BsBlurView: BsUIView {
    private var effect: UIBlurEffect!
    
    private let effectView = UIVisualEffectView(effect: nil).then {
        $0.isUserInteractionEnabled = false
    }
    
    private var animator: UIViewPropertyAnimator!
    
    /// 模糊效果
    open var effectStyle: UIBlurEffect.Style = .regular {
        didSet {
            effect = UIBlurEffect(style: effectStyle)
        }
    }
    
    /// 控制模糊程度，0~1
    @Clamp(0...1)
    open var intensity: Double = 1 {
        didSet {
            animator.fractionComplete = intensity
        }
    }
    
    deinit {
        animator.stopAnimation(true)
    }
    
    public convenience init(effectStyle: UIBlurEffect.Style = .regular, intensity: Double = 1) {
        self.init()
        self.effectStyle = effectStyle
        self.intensity = intensity
    }

    open override func onInit() {
        effect = UIBlurEffect(style: effectStyle)
        setupEffectView()
        setupAnimator()
    }
}

private extension BsBlurView {
    func setupEffectView() {
        addSubview(effectView)
        effectView.edgesEqualToSuperview()
    }
    
    func setupAnimator() {
        effectView.effect = nil
        let animation = { [weak self] in
            guard let self else { return }
            self.effectView.effect = self.effect
        }
        animator = UIViewPropertyAnimator(duration: 0, curve: .linear, animations: animation)
        animator.pausesOnCompletion = true
        animator.fractionComplete = intensity
    }
}
