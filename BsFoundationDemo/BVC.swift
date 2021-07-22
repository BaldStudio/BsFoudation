//
//  BVC.swift
//  BsFoundationDemo
//
//  Created by crzorz on 2021/7/20.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import UIKit
import BsFoundation

public class RootApplet: Applet {
    required init() {
        super.init()
        content = BVC()
    }
    
    public override var manifest: Manifest {
        Manifest([
            .name: "RootApplet",
            .id: "20200010",
            .version: "1.0.0",
        ])
    }

}

class BVC: UIViewController {
    deinit {
        print("没了BVC")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        Context.start(applet: ViewController.Key.find)
    }

}
