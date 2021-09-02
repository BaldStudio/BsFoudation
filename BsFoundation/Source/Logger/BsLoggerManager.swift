//
//  BsLoggerManager.swift
//  BsFoundation
//
//  Created by crzorz on 2021/8/19.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import Foundation

public final class BsLoggerManager {
    let cachePath: String
    let dateFormatter: DateFormatter
    
    let queue: DispatchQueue
    
    /// 日志文件结构的映射，key 是 fileDir，value 是 filePath 集合
    var fileMap: [String: Set<String>] = [:]
    
    /// 缓存所有 logger 实例，subsystem.category 为 key，实例为 value
    public private(set) var loggerMap: [String: BsLogger] = [:]

    public static let shared = BsLoggerManager()

    init() {
        cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                        .userDomainMask,
                                                        true).first ?? ""
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss:SSS"
        
        queue = DispatchQueue(label: "com.bald-studio.BsLogger")
    }
    
    /// 删除所有实例对应的日志文件
    public static func clearAll() {
        do {
            for dir in shared.fileMap.keys {
                try FileManager.default.removeItem(atPath: dir)
            }
        }
        catch {
            print("\(#file) line:\(#line) 删除失败: \(error)")
        }
    }
    
}

extension BsLoggerManager {
    static func updateFileMap(dir: String, path: String) {
        var set = shared.fileMap[dir] ?? []
        set.insert(path)
        shared.fileMap[dir] = set
    }
    
    static func add(logger: BsLogger) {
        shared.loggerMap[logger.subsystem + "." + logger.category] = logger
    }

    static func remove(logger: BsLogger) {
        shared.loggerMap[logger.subsystem + "." + logger.category] = nil
    }

}
