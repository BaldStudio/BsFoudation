//
//  UIControl+.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/16.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

private struct RuntimeKey {
    static var targetActions = 0
}

// MARK: - Common

public extension UIControl {
    func addTarget<T: AnyObject, Sender: UIControl>(_ target: T,
                                                    action: @escaping Action<T, Sender>,
                                                    for controlEvents: UIControl.Event) {
        removeTarget(self, for: controlEvents)
        let trigger: BlockT<UIControl> = { [weak target] sender in
            guard let target, let sender = sender as? Sender else { return }
            action(target)(sender)
        }
        targetActions = [
            TargetAction(target: target, action: trigger, controlEvents: controlEvents)
        ]
        addTarget(self, action: #selector(bs_onControlEvent), for: controlEvents)
    }

    func removeTarget<T: AnyObject>(_ target: T, for controlEvents: UIControl.Event) {
        targetActions.removeAll {
            $0.target === target && $0.controlEvents == controlEvents
        }
        removeTarget(self, action: #selector(bs_onControlEvent), for: controlEvents)
    }

    func onTouchUpInside(_ action: @escaping BlockT<UIControl>) {
        addTarget(self,
                  action: { (t: UIControl) -> BlockT<UIControl> in { action($0) } },
                  for: .touchUpInside)
    }
    
    func onValueChanged(_ action: @escaping BlockT<UIControl>) {
        addTarget(self,
                  action: { (t: UIControl) -> BlockT<UIControl> in { action($0) } },
                  for: .valueChanged)
    }
}

private extension UIControl {
    struct TargetAction {
        let target: AnyObject
        let action: BlockT<UIControl>
        let controlEvents: UIControl.Event
    }

    var targetActions: [TargetAction] {
        get {
            if let value: [TargetAction] = value(forAssociated: &RuntimeKey.targetActions) { return value }
            let value: [TargetAction] = []
            set(associate: value, for: &RuntimeKey.targetActions)
            return value
        }
        set {
            set(associate: newValue, for: &RuntimeKey.targetActions)
        }
    }

    @objc
    func bs_onControlEvent() {
        for trigger in targetActions {
            trigger.action(self)
        }
    }
}

