//
//  Device.swift
//  BsDevice
//
//  Created by crzorz on 2021/12/02.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import UIKit

public struct Device {
        
    /// unique identifier
    public static var uid = GUID.generate(mode: .disk)
    
}

extension Device {
    /// 设备分辨率的width
    public static let displayWidth = UIScreen.main.nativeBounds.width
    
    /// 设备分辨率的height
    public static let displayHeight = UIScreen.main.nativeBounds.height

    /// 设备分辨率的width，取width和height的大值
    public static let preferredDisplayWidth = fmax(displayWidth, displayHeight)
    
    /// 设备分辨率的height，取width和height的小值
    public static let preferredDisplayHeight = fmin(displayWidth, displayHeight)

    /// 设备分辨率的字符串，eg. @"1334x750"
    public static let displayResolution = "\(preferredDisplayWidth)x|\(preferredDisplayHeight)"
}
