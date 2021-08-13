//
//  BsLogger.swift
//  BsFoundation
//
//  Created by crzorz on 2021/7/21.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import Foundation

private let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                            .userDomainMask,
                                                            true).first ?? ""
private let dateFormatter = DateFormatter()

/// 日志文件结构的映射，key 是 fileDir，value 是 filePath 数组
private var logFileMapping: [String: Set<String>] = [:]

public final class BsLogger {
    
    /// 日志文件夹名
    public let subsystem: String
    
    /// 日志文件名
    public let category: String
    
    /// 日志文件所在的文件夹
    public private(set) var fileDir: String
    
    /// 日志文件的路径
    public let filePath: String
    
    /// 哪种级别的日志需要写到本地，默认 none
    public var persistentLevel: Level
        
    /// 当前可输出的日志类型，默认 verbose
    public var level: Level

    public init(subsystem: String, category: String) {
        self.subsystem = subsystem
        self.category = category
                
        fileDir = cachePath.appending("/" + subsystem)
        filePath = fileDir.appending("/" + category + ".log")

        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss:SSS"
        
        persistentLevel = .none
        
        level = .verbose
        
        updateFileMapping()
    }
        
    public func debug(_ message: String) {
        log(message, level: .debug)
    }

    public func info(_ message: String) {
        log(message, level: .info)
    }

    public func warning(_ message: String) {
        log(message, level: .warning)
    }

    public func error(_ message: String) {
        log(message, level: .error)
    }

}

// MARK: - Log Level

extension BsLogger {
    
    public struct Level: OptionSet {
        
        public let rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        public static let none = Level(rawValue: -1)

        public static let verbose: Level = [.debug, .info, .warning, .error]
        
        public static let debug = Level(rawValue: 1 << 0)
        public static let info = Level(rawValue: 1 << 1)
        public static let warning = Level(rawValue: 1 << 2)
        public static let error = Level(rawValue: 1 << 3)
    }
}

// MARK: - Log Format

extension BsLogger {
    
    func log(_ message: String, level lv: Level = .verbose) {
        var prefix: String
        switch lv {
        case .error:
            prefix = "❌ ERROR"
        case .warning:
            prefix = "⚠️ WARNING"
        case .info:
            prefix = "🟢 INFO"
        case .debug:
            prefix = "🟤 DEBUG"
        default:
            fatalError("好好想想，为什么会走到今天这一步")
        }
        
        let timestamp = dateFormatter.string(from: Date())
        let content = "\(timestamp) [\(category)] \(prefix) - \(message)"
        
        if persistentLevel != .none, persistentLevel.contains(lv) {
            append(log: content)
        }
        
        if level == .none { return }
        guard level.contains(lv) else { return }
        print(content)
    }

}

// MARK: - Log File Manager

extension BsLogger {
    
    /// 删除所有的日志，会影响所有实例的日志文件
    public static func clearAll() {
        do {
            for dir in logFileMapping.keys {
                try FileManager.default.removeItem(atPath: dir)
            }
        }
        catch {
            print("\(#file) line:\(#line) 删除失败: \(error)")
        }
    }
    
    /// 默认行为：找到当前实例所在的$subsystem目录，删除目录下所有日志
    /// 入参为 true，则只删除当前实例对应的 category 文件
    public func clear(category: Bool = false) {
        do {
            try FileManager.default.removeItem(atPath: category ? filePath : fileDir)
        }
        catch {
            print("\(#file) line:\(#line) 删除失败: \(error)")
        }
    }
    
    func updateFileMapping() {
        var set = logFileMapping[fileDir] ?? []
        set.insert(filePath)
        logFileMapping[fileDir] = set
    }
    
    func append(log string: String) {
        if !FileManager.default.fileExists(atPath: filePath) {
            createDirectoryIfNotExists()
            FileManager.default.createFile(atPath: filePath, contents: nil)
        }
        
        guard let url = URL(string: filePath),
              let fileHandle = try? FileHandle(forWritingTo: url)
        else {
            print("追加日志内容失败，\(filePath)")
            return
        }
        
        guard let content = ("\n" + string).data(using: .utf8) else {
            print("日志内容转码失败，UTF8，\(string)")
            return
        }
         
        fileHandle.seekToEndOfFile()
        fileHandle.write(content)

    }
    
    func createDirectoryIfNotExists() {
        
        var isDir = ObjCBool(false)
        if FileManager.default.fileExists(atPath: fileDir, isDirectory: &isDir) {
            if isDir.boolValue {
                return
            }
            // 存在同名文件，那我换名字呗
            logFileMapping[fileDir] = nil
            fileDir += ("_\(UUID().uuidString)")
            updateFileMapping()
        }

        do {
            try FileManager.default.createDirectory(at: URL(fileURLWithPath: fileDir),
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
        }
        catch {
            print("创建日志文件夹失败: \(error)")
        }
    }
}
