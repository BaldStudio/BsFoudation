//
//  Applet.swift
//  BsFoundation
//
//  Created by crzorz on 2020/9/27.
//  Copyright © 2020 BaldStudio. All rights reserved.
//

import UIKit

open class Applet {
    deinit {
        logger.debug("销毁 \(description)")
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
        logger.debug("\(description) \(#function)")
    }

    open func didFinishLaunching(options: [String: Any]? = nil) {
        logger.debug("\(description) \(#function)")
    }
     
    open func didEnterBackground() {
        logger.debug("\(description) \(#function)")
    }

    open func willEnterForeground() {
        logger.debug("\(description) \(#function)")
    }
    
    open func willTerminate() {
        logger.debug("\(description) \(#function)")
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

extension Applet: CustomStringConvertible {
    public var description: String {
        manifest.description
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
        
    func transition() {
        guard let trasnCoor = transitionCoordinator else {
            logger.debug("transitionCoordinator is nil；ARE YOU KIDDING ME?")
            return
        }
        
        trasnCoor.animate(alongsideTransition: nil) {
            if $0.isCancelled {
                logger.debug("取消操作：滑动返回")
                return
            }
            
            if $0.presentationStyle == .none {
                logger.debug("转场类型为 push/pop")
                return
            }
            
            // 处理Modal视图控制器的行为
            guard let fromApplet = self.applet else {
                logger.debug("\(self) 所属的 Applet 为 nil")
                return
            }
            
            guard let vc = $0.viewController(forKey: .to) else {
                logger.debug("转场的目标控制器为 nil")
                return
            }
            
            guard vc is AppletController else {
                logger.debug("目标控制器不是 AppletController 类型, 无需切换 Applet")
                return
            }
            
            let toVC = vc as! AppletController
                        
            guard let toApplet = toVC.applet else {
                logger.debug("\(self) 所属的 Applet 为 nil")
                return
            }
            
            logger.debug("from \(fromApplet.description)")
            logger.debug("to \(toApplet.description)")
            
            if Context.currentApplet == fromApplet {
                logger.debug("更新应用栈数据，当前栈顶 \(fromApplet.description)")
                Context.appletManager.pop()
            }
        }
    }
    
    func transition(from parent: UIViewController?) {
        if parent == nil { // remove
            guard let vc = Context.navigationController?.topViewController else {
                logger.debug("导航栈是空的")
                return
            }
            
            guard vc is AppletController else {
                logger.debug("目标控制器不是 AppletController 类型")
                if let topApplet = Context.currentApplet {
                    /*
                     前置的是普通ViewController，不是Applet根视图
                     所以栈同步需要放在这里去做掉
                    */
                    logger.debug("更新应用栈数据，当前栈顶 \(topApplet.description)")
                    Context.appletManager.pop()
                }
                return
            }
            
            let toVC = vc as! AppletController
            
            guard let toApplet = toVC.applet else {
                logger.debug("\(self) 所属的 Applet 为 nil")
                return
            }

            logger.debug("更新应用栈数据，当前栈顶 \(toApplet.description)")
            Context.appletManager.pop()
        }
    }
}
