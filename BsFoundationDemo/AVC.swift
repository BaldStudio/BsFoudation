//
//  AVC.swift
//  BsFoundationDemo
//
//  Created by crzorz on 2021/7/19.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import UIKit
import BsFoundation

public class FindApplet: Applet {
    required init() {
        super.init()
        content = AVC()
    }
    
    public override var manifest: Manifest {
        Manifest([
            .name: "FindApplet",
            .id: "20200011",
            .version: "1.0.0",
        ])
    }

}

class AVC: UIViewController {    
    deinit {
        print("没了AVC")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

    }
    
    
}
