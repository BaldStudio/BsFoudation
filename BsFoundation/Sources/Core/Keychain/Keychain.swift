//
//  Keychain.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/31.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

@dynamicCallable
public struct Keychain {
    /// Keychain items with share access same group
    public var accessGroup: String?
    
    public init(accessGroup: String? = nil) {
        self.accessGroup = accessGroup
    }

    public func set<T: KeychainSerializable>(_ value: T.Value, for key: Key<T>) throws {
        try T.serializer.set(value, forKey: key, in: self)
    }
    
    public func value<T: KeychainSerializable>(for key: Key<T>) throws -> T.Value? {
        try T.serializer.value(for: key, in: self)
    }
    
    public func value<T: KeychainSerializable>(for key: Key<T>,
                                               default defaultValue: @autoclosure () -> T.Value) throws -> T.Value {
        do {
            if let value = try T.serializer.value(for: key, in: self) {
                return value
            }
            return defaultValue()
        } catch {
            throw error
        }
    }
    
    public func removeValue<T: KeychainSerializable>(for key: Key<T>) throws {
        try T.serializer.removeValue(for: key, in: self)
    }
    
    /// Remove all keys from specific keychain of item type
    public func deleteItem(_ type: ItemType) throws {
        var attributes = AnyAttributes()
        attributes += queryAttributes
        attributes.append(Attribute.item(type))
        attributes.append(Attribute.SynchronizableAny())

        let status = Keychain.deleteItem(attributes)
        if status != errSecSuccess, status != errSecItemNotFound {
            throw KeychainError(status: status)
        }
    }
    
    /// Remove all keys from specific keychain
    public func deleteAll() throws {
        try deleteItem(.genericPassword)
        try deleteItem(.internetPassword)
    }

    public func attributes<T: KeychainSerializable>(for key: Key<T>) throws -> [Keychain.Attribute] {
        try T.serializer.attributes(for: key, in: self)
    }
    
    public subscript<T: KeychainSerializable>(key: Key<T>) -> Result<T.Value?, KeychainError> {
        do {
            return .success(try value(for: key))
        } catch {
            return .failure(KeychainError(error))
        }
    }
    
    public subscript<T: KeychainSerializable>(key: Key<T>, 
                                              default defaultValue: @autoclosure () -> T.Value) -> Result<T.Value, KeychainError> {
        do {
            return .success(try value(for: key, default: defaultValue()))
        } catch {
            return .failure(KeychainError(error))
        }
    }
    
    public func dynamicallyCall<T: KeychainSerializable>(withArguments args: [Key<T>]) throws -> T.Value? {
        try value(for: args[0])
    }
    
    public func dynamicallyCall<T: KeychainSerializable>(withArguments args: [Key<T>]) -> Result<T.Value?, KeychainError> {
        do {
            return .success(try value(for: args[0]))
        } catch {
            return .failure(KeychainError(error))
        }
    }
}

extension Keychain {
    /// Build keychain search request attributes
    var queryAttributes: AnyAttributes {
        var attributes = AnyAttributes()
        accessGroup.flatMap { attributes.append(Attribute.accessGroup($0)) }
        return attributes
    }
}

// MARK: -  Security API Wrapper

extension Keychain {
    static func deleteItem(_ attributes: AnyAttributes) -> OSStatus {
        SecItemDelete(attributes.compose())
    }

    static func addItem(_ attributes: AnyAttributes) -> OSStatus {
        SecItemAdd(attributes.compose(), nil)
    }
    
    static func updateItem(_ query: AnyAttributes, _ attributesToUpdate: AnyAttributes) -> OSStatus {
        SecItemUpdate(query.compose(), attributesToUpdate.compose())
    }

    static func fetchItem(_ attributes: AnyAttributes) -> OSStatus {
        SecItemCopyMatching(attributes.compose(), nil)
    }
}
