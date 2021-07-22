//
//  ViewController.swift
//  BsFoundationDemo
//
//  Created by TongDi on 2021/1/12.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import UIKit
import BsFoundation

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Context.navigationController = navigationController!
        Context.setApplets(appletMap)
        
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        show(BVC(), sender: nil)
        Context.start(applet: Key.root)
    }
}

extension ViewController {
    public struct Key {
        public static let root = "20200010"
        public static let find = "20200011"

    }

    public var appletMap: [String : [Manifest.Key : String]] {
        return [
            Key.root: [
                .name: "BsFoundationDemo.RootApplet",
                .id: "20200010",
                .version: "1.0.0",
            ],
            Key.find: [
                .name: "BsFoundationDemo.FindApplet",
                .id: "20200011",
                .version: "1.0.0",
            ],
        ]
    }

}
