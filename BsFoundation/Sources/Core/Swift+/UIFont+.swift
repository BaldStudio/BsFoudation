//
//  UIFont+.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/16.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

import Foundation

public extension UIFont {
    /// iOS上注册的字体都是进程级别的，每次启动都需要注册一遍
    @discardableResult
    static func registerFont(with fileURL: URL) -> Bool {
        var isDir = ObjCBool(false)
        guard FileManager.default.fileExists(atPath: fileURL.absoluteString,
                                             isDirectory: &isDir),
              !isDir.boolValue else {
            logger.error("字体注册失败，路径不合法，fileURL: \(fileURL)")
            return false
        }
        
        var error: Unmanaged<CFError>?
        let cfURL = fileURL as CFURL
        if !CTFontManagerRegisterFontsForURL(cfURL,
                                             .process,
                                             &error) {
            if let error = error?.takeUnretainedValue() {
                logger.error("字体注册失败，error: \(error.localizedDescription)")
            } else {
                logger.error("字体注册失败，error: Unknown")
            }
            return false
        }
        return true
    }
    
    /// 注册某个文件夹下的所有字体
    static func registerFonts(at path: String) {
        guard let fileNames = try? FileManager.default.contentsOfDirectory(atPath: path),
              !fileNames.isEmpty else {
            logger.debug("当前路径下找不到有效内容 path: \(path)")
            return
        }
        
        guard let directoryURL = URL(string: path) else {
            logger.debug("当前路径不合法，path: \(path)")
            return
        }
        
        for fileName in fileNames {
            let url = directoryURL.appendingPathComponent(fileName)
            registerFont(with: url)
        }
    }

}
