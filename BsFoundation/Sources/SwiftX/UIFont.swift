//
//  UIFont.swift
//  BsFoundation
//
//  Created by crzorz on 2022/6/4.
//  Copyright © 2022 BaldStudio. All rights reserved.
//

import UIKit

private let fm = FileManager.default

public extension SwiftX where T: UIFont {
    
    /// iOS上注册的字体都是进程级别的，每次启动都需要注册一遍
    @discardableResult
    static func registerFont(with fileURL: URL) -> Bool {
        var isDir = ObjCBool(false)
        guard fm.fileExists(atPath: fileURL.absoluteString,
                            isDirectory: &isDir), !isDir.boolValue else {
            logger.debug("字体文件的路径不合法，path: \(fileURL)")
            return false
        }
        
        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterFontsForURL(fileURL as CFURL,
                                            .process,
                                            &error) {
            if let error = error?.takeUnretainedValue() {
                logger.debug("字体注册失败，error: \(error.localizedDescription)")
            }
            else {
                logger.debug("字体注册失败，error: Unknown")
            }
        }
        
        return true
    }
    
    /// 注册某个文件夹下的所有字体
    static func registerFonts(at path: String) {
        guard let filNames = try? fm.contentsOfDirectory(atPath: path),
              !filNames.isEmpty else {
            logger.debug("当前路径下找不到有效内容 path: \(path)")
            return
        }
        
        guard let fileURL = URL(string: path) else {
            logger.debug("当前路径不合法，path: \(path)")
            return
        }
        
        for fileName in filNames {
            let url = fileURL.appendingPathComponent(fileName)
            registerFont(with: url)
        }
    }

}
