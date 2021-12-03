//
//  Applet.swift
//  BsFoundation
//
//  Created by crzorz on 2020/9/27.
//  Copyright © 2020 BaldStudio. All rights reserved.
//

import UIKit

open class Applet {
    static var environment: AppletEnvironment?
    
    public func setupEnvironment(_ env: AppletEnvironment) {
        Self.environment = env
    }

    public static func currentEnvironment<E>() -> E? {
        environment as? E
    }
    
    deinit {
        Self.environment?.dispose()
        Self.environment = nil
        logger.debug("销毁 \(manifest.name)")
    }
    
    public required init() {

    }

    var launched = false
    
    var root = AppletController()
            
    public var content: UIViewController? {
        willSet {
            guard let vc = newValue else {
                if let child = content {
                    child.willMove(toParent: nil)
                    child.removeFromParent()
                    child.view.removeFromSuperview()
                }
                return
            }
            
            root.applet = self
            root.addChild(vc)
            root.view.addSubview(vc.view)
            vc.didMove(toParent: root)
        }
    }
        
    public internal(set) var manifest: Manifest!
    
    open var shouldTerminate: Bool {
        true
    }
    
    open func willFinishLaunching(options: [String: Any]? = nil) {
        logger.debug("\(manifest.name) \(#function)")
    }

    open func didFinishLaunching(options: [String: Any]? = nil) {
        logger.debug("\(manifest.name) \(#function)")
    }
     
    open func didEnterBackground() {
        logger.debug("\(manifest.name) \(#function)")
    }

    open func willEnterForeground() {
        logger.debug("\(manifest.name) \(#function)")
    }
    
    open func willTerminate() {
        logger.debug("\(manifest.name) \(#function)")
    }
    
    public static var bundleName: String = ""
    
    open class var bundle: Bundle? {
        Bundle(path: Bundle.main.path(forResource: bundleName, ofType: "bundle") ?? "")
    }

}

extension Applet: Equatable {
    public static func == (lhs: Applet, rhs: Applet) -> Bool {
        lhs === rhs
    }
}

extension Applet: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        String(format: "<name: \(manifest.name) version: \(manifest.version) >")
    }
    
    public var debugDescription: String {
//        let addr = unsafeBitCast(self, to: Int.self)
//        return String(format: "<name: \(manifest.name) %p version: \(manifest.version) >", addr)
        String(format: "\(manifest.name)")
    }
}

class AppletController: BsViewController {
    weak var applet: Applet?
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        transition()
    }

    public override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        transition(from: parent)
    }
    
    public override var shouldAutorotate: Bool {
        children.first?.shouldAutorotate ?? super.shouldAutorotate
    }
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        children.first?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
    }
    
    public override var childForStatusBarStyle: UIViewController? {
        children.first
    }
    
    public override var childForStatusBarHidden: UIViewController? {
        children.first
    }
    
    func transition() {
        guard let trasnCoor = transitionCoordinator else {
            logger.debug("transitionCoordinator is nil；ARE YOU KIDDING ME?")
            return
        }
        
        trasnCoor.animate(alongsideTransition: nil) {
            if ($0.isCancelled) {
                logger.debug("取消 -= 滑动返回 =- 操作")
                return
            }
            
            if $0.presentationStyle == .none {
                logger.debug("转场类型为 push/pop")
                return
            }
            
            // 处理Modal视图控制器的行为
            guard let fromApplet = self.applet else {
                logger.debug("\(self)所属的applet为nil")
                return
            }
            
            guard let vc = $0.viewController(forKey: .to) else {
                logger.debug("转场的目标控制器为nil")
                return
            }
            
            guard vc is AppletController else {
                logger.debug("不是 AppletController, 无需切换 Applet")
                return
            }
            
            let toVC = vc as! AppletController
                        
            guard let toApplet = toVC.applet else {
                logger.debug("\(self)所属的applet为nil")
                return
            }
            
            logger.debug("from \(fromApplet.manifest.name)")
            logger.debug("to \(toApplet.manifest.name)")
            
            if Context.currentApplet == fromApplet {
                logger.debug("更新Applet栈数据，当前栈顶 \(fromApplet.manifest.name)")
                Context.appletManager.pop()
            }
        }
    }
    
    func transition(from parent: UIViewController?) {
        if parent == nil { // remove
            guard let vc = Context.navigationController.topViewController else {
                logger.debug("导航栈是空的")
                return
            }
            
            guard vc is AppletController else {
                logger.debug("不是 AppletController")
                if let topApplet = Context.currentApplet {
                    /*
                     前置的是普通ViewController，不是Applet根视图
                     所以栈同步需要放在这里去做掉
                    */
                    logger.debug("更新Applet栈数据，当前栈顶 \(topApplet.manifest.name)")
                    Context.appletManager.pop()
                }
                return
            }
            
            let toVC = vc as! AppletController
            
            guard let toApplet = toVC.applet else {
                logger.debug("\(self)所属的applet为nil")
                return
            }

            logger.debug("更新Applet栈数据，当前栈顶 \(toApplet.manifest.name)")
            Context.appletManager.pop()
        }
    }
}
