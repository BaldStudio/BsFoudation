//
//  Runtime.swift
//  BsFoundation
//
//  Created by crzorz on 2021/9/3.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

import Foundation

public protocol AnyOptional {
    
    var isNil: Bool { get }
    
}

extension Optional: AnyOptional {
    
    @inlinable
    public var isNil: Bool {
        self == nil
    }
    
}

// MARK: - Associated Object

private class WeakValueHolder {
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
        set(associate: WeakValueHolder(value), for: key, atomic: false)
    }
    
    func set(associateWeak value: AnyObject?, for key: UnsafeRawPointer, atomic: Bool = false) {
        set(associateCopy: WeakValueHolder(value), for: key, atomic: false)
    }
    
    static func value<T>(forAssociated key: UnsafeRawPointer) -> T? {
        let value = objc_getAssociatedObject(self, key)
        if let value = value as? WeakValueHolder {
            return value.value as? T
        }
        return value as? T
    }
    
    func value<T>(forAssociated key: UnsafeRawPointer) -> T? {
        let value = objc_getAssociatedObject(self, key)
        if let value = value as? WeakValueHolder {
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
