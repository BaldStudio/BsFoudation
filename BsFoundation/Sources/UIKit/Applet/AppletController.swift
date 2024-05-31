//
//  AppletController.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/30.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

class AppletController: BsUIViewController {
    weak var applet: Applet?
    
    required init(applet: Applet) {
        super.init(nibName: nil, bundle: nil)
        self.applet = applet
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let trasnCoor = transitionCoordinator else {
            logger.debug("transitionCoordinator is nil")
            return
        }
        trasnCoor.animate(alongsideTransition: nil) {
            // 检查转场状态
            if $0.isCancelled {
                logger.debug("取消操作：滑动返回")
                return
            }
            if $0.presentationStyle == .none {
                logger.debug("转场类型为 push/pop")
                return
            }
            // 检查转场上下文信息
            guard let fromApplet = self.applet else {
                logger.debug("\(self) 所属的 Applet 为 nil")
                return
            }
            guard let toVC = $0.viewController(forKey: .to) else {
                logger.debug("转场的目标控制器为 nil")
                return
            }
            guard let toVC = toVC as? AppletController else {
                logger.debug("目标控制器不是 AppletController 类型, 无需切换 Applet")
                return
            }
            guard let toApplet = toVC.applet else {
                logger.debug("\(self) 所属的 Applet 为 nil")
                return
            }
            
            logger.debug("from \(fromApplet.description)")
            logger.debug("to \(toApplet.description)")

            guard AppletContext.shared.currentApplet == fromApplet else { return }
            AppletContext.shared.popApplet()
        }
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        guard parent.isNil else {
            logger.debug("当前控制器被添加到\(parent!)")
            return
        }
        guard let topViewController = AppletContext.shared.navigationController.topViewController else {
            logger.debug("导航栈是空的")
            return
        }
        guard let toVC = topViewController as? AppletController else {
            /*
             前置的是普通ViewController，不是AppletController
             所以栈同步需要放在这里去做掉
            */
            AppletContext.shared.popApplet()
            return
        }
        guard toVC.applet.isNotNil else {
            logger.debug("\(self) 关联的 Applet 为 nil")
            return
        }
        AppletContext.shared.popApplet()
    }
}
