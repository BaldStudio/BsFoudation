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
    
    open var effectStyle: UIBlurEffect.Style = .regular {
        didSet {
            effect = UIBlurEffect(style: effectStyle)
        }
    }
    
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

    open override func commonInit() {
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
        animator = UIViewPropertyAnimator(duration: 0, curve: .linear, animations: { [weak self] in
            guard let self else { return }
            self.effectView.effect = self.effect
        })
        animator.pausesOnCompletion = true
        animator.fractionComplete = intensity
    }
}
