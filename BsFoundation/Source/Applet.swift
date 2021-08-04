//
//  Applet.swift
//  BsFoundation
//
//  Created by TongDi on 2020/9/27.
//  Copyright © 2020 BaldStudio. All rights reserved.
//

import UIKit

open class Applet {
    deinit {
        logger.debug("销毁 \(manifest.name)")
    }
    
    var controller = _AppletController()
        
    public internal(set) var state: State = .normal

    public var content: UIViewController? {
        willSet {
            guard let vc = newValue else {
                content?.willMove(toParent: nil)
                content?.removeFromParent()
                content?.view.removeFromSuperview()
                return
            }
            
            controller.applet = self
            controller.addChild(vc)
            controller.view.addSubview(vc.view)
            vc.didMove(toParent: controller)
        }
    }
    
    public required init() {
        logger.debug("初始化 \(manifest.name)")
    }
        
    open var manifest: Manifest {
        fatalError("子类必须实现manifest内容")
    }
    
    open var shouldTerminate: Bool {
        true
    }
    
    open func willFinishLaunching(options: [String: Any]? = nil) {
        logger.debug("\(manifest.name) ++++ " + "\(#function)")
    }

    open func didFinishLaunching(options: [String: Any]? = nil) {
        logger.debug("\(manifest.name) ++++ " + "\(#function)")
    }
     
    open func didEnterBackground() {
        logger.debug("\(manifest.name) ++++ " + "\(#function)")
    }

    open func willEnterForeground() {
        logger.debug("\(manifest.name) ++++ " + "\(#function)")
    }
    
    open func willTerminate() {
        logger.debug("\(manifest.name) ++++ " + "\(#function)")
    }

}

public extension Applet {
    enum State {
        case normal
        case pending
    }
}

extension Applet: Equatable {
    public static func == (lhs: Applet, rhs: Applet) -> Bool {
        lhs === rhs
    }
}

extension Applet: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        let addr = unsafeBitCast(self, to: Int.self)
        return String(format: "<name: \(manifest.name) %p version: \(manifest.version) >", addr)
    }
    
    public var debugDescription: String {
        let addr = unsafeBitCast(self, to: Int.self)
        return String(format: "<name: \(manifest.name) %p version: \(manifest.version) >", addr)
    }
}

class _AppletController: UIViewController {
    
    func onTransition() {
        transitionCoordinator?.animate(alongsideTransition: nil, completion: { (ctx) in
            // toVC和当前vc所属app不同 且当前vc的app不为空 那么 需要进行app栈信息同步
            guard !ctx.isCancelled else { logger.debug("取消手势操作"); return }
            guard ctx.presentationStyle != .none else { logger.debug("是 push/pop 行为"); return }

            guard let curApp = self.applet else { logger.debug("\(self)所属的applet为空"); return }
            var toVC = ctx.viewController(forKey: .to)
            if toVC is UINavigationController {
                toVC = toVC?.children.last
            }
            guard let toApp = toVC!.applet else { logger.debug("\(toVC!)所属的app为空"); return }
            
            logger.debug("vc所属的app为\(curApp.manifest.name)")
            logger.debug("toVC所属的app为\(toApp.manifest.name)")
            if toApp != curApp && Context.currentApplet == curApp {
                logger.debug("触发app栈同步，栈当前应用\(curApp.manifest.name)")
                Context.shared.appletManager.pop()
            }
        })
    }
    
    func transition(from parent: UIViewController?) {
        if parent == nil { // remove
            let nav = Context.navigationController
            let topvc = nav.children.last!
            if topvc.applet != nil, topvc.applet != Context.currentApplet {
                logger.debug("触发app栈同步，出栈当前应用\(Context.currentApplet!.manifest.name)")
                Context.shared.appletManager.pop()
            }
        }
        
//        else if let app = self.applet {
//            BsLog.debug("触发app栈同步，入栈当前应用\(Context.currentApplet)")
//            Context.shared.appletManager.push(applet: app)
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        onTransition()
    }

    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        transition(from: parent)
    }
    
}

var AppletReferenceKey = "com.bald-studio.viewController.AppletReferenceKey"

extension UIViewController {
    struct WeakReference {
        weak var rawValue: Applet?
        init(_ rawValue: Applet?) {
            self.rawValue = rawValue
        }
    }
    var applet: Applet? {
        set {
            logger.debug("\(self) 绑定至Applet \(newValue!.manifest.name)")
            objc_setAssociatedObject(self,
                                     &AppletReferenceKey,
                                     WeakReference(newValue),
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            let ref = objc_getAssociatedObject(self, &AppletReferenceKey) as? WeakReference
            return ref?.rawValue
        }
    }
}
