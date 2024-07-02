//
//  NSObject+.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/6/3.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

// MARK: - Associated Object

private class WeakWrapper {
    weak var value: AnyObject?
    required init(_ value: AnyObject?) {
        self.value = value
    }
}

extension NSObject: ObjectAssociatable {}

public protocol ObjectAssociatable: AnyObject {
    static func set(associate value: Any?, for key: UnsafeRawPointer, atomic: Bool)
    func set(associate value: Any?, for key: UnsafeRawPointer, atomic: Bool)
    
    static func set(associateCopy value: Any?, for key: UnsafeRawPointer, atomic: Bool)
    func set(associateCopy value: Any?, for key: UnsafeRawPointer, atomic: Bool)
    
    static func set(associateWeak value: AnyObject?, for key: UnsafeRawPointer, atomic: Bool)
    func set(associateWeak value: AnyObject?, for key: UnsafeRawPointer, atomic: Bool)
    
    static func value<T>(forAssociated key: UnsafeRawPointer) -> T?
    func value<T>(forAssociated key: UnsafeRawPointer) -> T?
    
    static func removeAllAssociatedObjects()
    func removeAllAssociatedObjects()
}

public extension ObjectAssociatable {
    static func set(associate value: Any?, for key: UnsafeRawPointer, atomic: Bool = false) {
        objc_setAssociatedObject(self,
                                 key,
                                 value,
                                 atomic ? .OBJC_ASSOCIATION_RETAIN : .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func set(associate value: Any?, for key: UnsafeRawPointer, atomic: Bool = false) {
        objc_setAssociatedObject(self,
                                 key,
                                 value,
                                 atomic ? .OBJC_ASSOCIATION_RETAIN : .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
        
    static func set(associateCopy value: Any?, for key: UnsafeRawPointer, atomic: Bool = false) {
        objc_setAssociatedObject(self,
                                 key,
                                 value,
                                 atomic ? .OBJC_ASSOCIATION_COPY : .OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
    
    func set(associateCopy value: Any?, for key: UnsafeRawPointer, atomic: Bool = false) {
        objc_setAssociatedObject(self,
                                 key,
                                 value,
                                 atomic ? .OBJC_ASSOCIATION_COPY : .OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
    
    static func set(associateWeak value: AnyObject?, for key: UnsafeRawPointer, atomic: Bool = false) {
        set(associate: WeakWrapper(value), for: key, atomic: atomic)
    }
    
    func set(associateWeak value: AnyObject?, for key: UnsafeRawPointer, atomic: Bool = false) {
        set(associate: WeakWrapper(value), for: key, atomic: atomic)
    }
    
    static func value<T>(forAssociated key: UnsafeRawPointer) -> T? {
        let value = objc_getAssociatedObject(self, key)
        if let value = value as? WeakWrapper {
            return value.value as? T
        }
        return value as? T
    }
    
    func value<T>(forAssociated key: UnsafeRawPointer) -> T? {
        let value = objc_getAssociatedObject(self, key)
        if let value = value as? WeakWrapper {
            return value.value as? T
        }
        return value as? T
    }
    
    static func removeAllAssociatedObjects() {
        objc_removeAssociatedObjects(self)
    }
    
    func removeAllAssociatedObjects() {
        objc_removeAssociatedObjects(self)
    }
}

// MARK: -  Copy & MutableCopy

public extension NSObject {
    func asMutableCopy<T: NSMutableCopying>() -> T {
        mutableCopy() as! T
    }

    func asCopy<T: NSCopying>() -> T {
        copy() as! T
    }
}
