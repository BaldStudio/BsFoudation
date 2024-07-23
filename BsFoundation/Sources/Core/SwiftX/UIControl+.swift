//
//  UIControl+.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/16.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

// MARK: - Common

public extension UIControl {
    func addTarget<T: AnyObject, Sender: UIControl>(_ target: T,
                                                    action: @escaping Action<T, Sender>,
                                                    for controlEvents: UIControl.Event) {
        removeTarget(self, for: controlEvents)
        let block: BlockT<UIControl> = { [weak target] sender in
            guard let target, let sender = sender as? Sender else { return }
            action(target)(sender)
        }
        bs_pointerEvents = [
            UIControl.PointerEvent(target: target, action: block, controlEvents: controlEvents)
        ]
        addTarget(self, action: #selector(bs_onControlEvent), for: controlEvents)
    }

    func removeTarget<T: AnyObject>(_ target: T, for controlEvents: UIControl.Event) {
        bs_pointerEvents.removeAll {
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

private enum RuntimeKey {
    static var pointerEvents = 0
}

private extension UIControl {
    struct PointerEvent {
        let target: AnyObject
        let action: BlockT<UIControl>
        let controlEvents: UIControl.Event
    }

    var bs_pointerEvents: [PointerEvent] {
        get {
            if let value: [PointerEvent] = value(forAssociated: &RuntimeKey.pointerEvents) { return value }
            let value: [PointerEvent] = []
            set(associate: value, for: &RuntimeKey.pointerEvents)
            return value
        }
        set {
            set(associate: newValue, for: &RuntimeKey.pointerEvents)
        }
    }

    @objc
    func bs_onControlEvent() {
        for event in bs_pointerEvents {
            event.action(self)
        }
    }
}
