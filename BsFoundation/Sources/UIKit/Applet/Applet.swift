//
//  Applet.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/30.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

public protocol AppletDelegate {
    var contentViewController: UIViewController { get }
        
    func appletWillFinishLaunching(_ applet: Applet, options: [String: Any])

    func appletDidFinishLaunching(_ applet: Applet)

    func appletDidBecomeActive(_ applet: Applet)

    func appletWillResignActive(_ applet: Applet)

    func appletWillTerminate(_ applet: Applet)
}

public extension AppletDelegate {
    func appletWillFinishLaunching(_ applet: Applet, options: [String: Any]) {}

    func appletDidFinishLaunching(_ applet: Applet) {}

    func appletDidBecomeActive(_ applet: Applet) {}

    func appletWillResignActive(_ applet: Applet) {}

    func appletWillTerminate(_ applet: Applet) {}
}

public class Applet {
    var isLaunched = false
    
    lazy var appletController: AppletController = AppletController(applet: self)
    
    public internal(set) var manifest: Manifest!
    
    public var delegate: AppletDelegate?
    
    required init() {

    }
}

extension Applet: CustomStringConvertible, Equatable {
    public var description: String {
        manifest.description
    }
    
    public static func == (lhs: Applet, rhs: Applet) -> Bool {
        lhs === rhs
    }
}
