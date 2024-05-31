//
//  KeychainAttribute.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/31.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

protocol AttributeRepresentable {
    typealias Element = (key: CFString, value: Any)
    var element: Element { get }
}

typealias AnyAttributes = [AttributeRepresentable]

extension AnyAttributes {
    func compose() -> CFDictionary {
        map(\.element).reduce(into: [CFString: Any]()) { $0[$1.key] = $1.value } as CFDictionary
    }
}

// MARK: -  Search Result

extension Keychain.Attribute {
    enum SearchResult: AttributeRepresentable {
        case matchLimit(MatchLimit)

        enum MatchLimit {
            case one
            case all
            
            var rawValue: CFString {
                switch self {
                    case .one:
                        return kSecMatchLimitOne
                    case .all:
                        return kSecMatchLimitAll
                }
            }
        }
        
        var element: Element {
            switch self {
                case .matchLimit(let matchLimit):
                    return (key: kSecMatchLimit, value: matchLimit.rawValue)
            }
        }
    }
}

// MARK: -  Return Result

extension Keychain.Attribute {
    enum ReturnResult: AttributeRepresentable {
        case data(Bool)
        case attributes(Bool)
        case reference(Bool)
        case persistentReference(Bool)
        
        var element: Element {
            switch self {
                case .data(let value):
                    return (key: kSecReturnData, value: value)
                case .attributes(let value):
                    return (key: kSecReturnAttributes, value: value)
                case .reference(let value):
                    return (key: kSecReturnRef, value: value)
                case .persistentReference(let value):
                    return (key: kSecReturnPersistentRef, value: value)
            }
        }
    }
}

// MARK: -  Synchronizable Any

extension Keychain.Attribute {
    struct SynchronizableAny: AttributeRepresentable {
        var element: Element { (key: kSecAttrSynchronizable, value: kSecAttrSynchronizableAny) }
    }
}

// MARK: -  Attribute

extension Keychain {
    public enum Attribute: Equatable, AttributeRepresentable {
        case item(ItemType)
        case service(String)
        case accessible(AccessibilityLevel)
        case accessGroup(String)
        case synchronizable(Bool)
        case server(String)
        case port(Int)
        case scheme(ProtocolType)
        case authentication(AuthenticationType)
        case securityDomain(String)
        case path(String)
        case data(Data)
        case account(String)
        case label(String)
        case comment(String)
        case description(String)
        case isInvisible(Bool)
        case isNegative(Bool)
        case generic(Data)
        case creator(String)
        case type(String)
        case creationDate(Date)
        case modificationDate(Date)
        
        var element: Element {
            switch self {
            case .item(let value):
                return (key: kSecClass, value: value.rawValue)
            case .service(let value):
                return (key: kSecAttrService, value: value)
            case .accessible(let level):
                return (key: kSecAttrAccessible, value: level.rawValue)
            case .accessGroup(let value):
                return (key: kSecAttrAccessGroup, value: value)
            case .synchronizable(let value):
                return (key: kSecAttrSynchronizable, value: value)
            case .server(let value):
                return (key: kSecAttrServer, value: value)
            case .port(let value):
                return (key: kSecAttrPort, value: value)
            case .scheme(let value):
                return (key: kSecAttrProtocol, value: value.rawValue)
            case .authentication(let value):
                return (key: kSecAttrAuthenticationType, value: value.rawValue)
            case .securityDomain(let value):
                return (key: kSecAttrSecurityDomain, value: value)
            case .path(let value):
                return (key: kSecAttrPath, value: value)
            case .data(let data):
                return (key: kSecValueData, value: data)
            case .account(let value):
                return (key: kSecAttrAccount, value: value)
            case .label(let value):
                return (key: kSecAttrLabel, value: value)
            case .comment(let value):
                return (key: kSecAttrComment, value: value)
            case .description(let value):
                return (key: kSecAttrDescription, value: value)
            case .isInvisible(let value):
                return (key: kSecAttrIsInvisible, value: NSNumber(value: value))
            case .isNegative(let value):
                return (key: kSecAttrIsNegative, value: NSNumber(value: value))
            case .generic(let value):
                return (key: kSecAttrGeneric, value: value)
            case .creator(let value):
                return (key: kSecAttrCreator, value: value)
            case .type(let value):
                return (key: kSecAttrType, value: value)
            case .creationDate(let value):
                return (key: kSecAttrCreationDate, value: value)
            case .modificationDate(let value):
                return (key: kSecAttrModificationDate, value: value)
            }
        }
        
        init?(key: String, value: Any) {
            switch key {
                case kSecClass as CFString:
                    guard let type = ItemType(rawValue: value as! CFString) else { return nil }
                    self = .item(type)
                case String(kSecAttrService):
                    self = .service(value as! String)
                case String(kSecAttrAccessible):
                    guard let lv = AccessibilityLevel(rawValue: value as! CFString) else { return nil }
                    self = .accessible(lv)
                case String(kSecAttrAccessGroup):
                    self = .accessGroup(value as! String)
                case String(kSecAttrSynchronizable):
                    guard let synchronizable = Bool(cfNumber: value as! CFNumber) else { return nil }
                    self = .synchronizable(synchronizable)
                case String(kSecAttrServer):
                    self = .server(value as! String)
                case String(kSecAttrPort):
                    self = .port(value as! Int)
                case String(kSecAttrProtocol):
                    guard let type = ProtocolType(rawValue: value as! CFString) else { return nil }
                    self = .scheme(type)
                case String(kSecAttrAuthenticationType):
                    guard let type = AuthenticationType(rawValue: value as! CFString) else { return nil }
                    self = .authentication(type)
                case String(kSecAttrSecurityDomain):
                    self = .securityDomain(value as! String)
                case String(kSecAttrPath):
                    self = .path(value as! String)
                case String(kSecValueData):
                    self = .data(value as! Data)
                case String(kSecAttrAccount):
                    self = .account(value as! String)
                case String(kSecAttrLabel):
                    self = .label(value as! String)
                case String(kSecAttrComment):
                    self = .comment(value as! String)
                case String(kSecAttrDescription):
                    self = .description(value as! String)
                case String(kSecAttrIsInvisible):
                    self = .isInvisible(value as! Bool)
                case String(kSecAttrIsNegative):
                    self = .isNegative(value as! Bool)
                case String(kSecAttrGeneric):
                    self = .generic(value as! Data)
                case String(kSecAttrCreator):
                    self = .creator(value as! String)
                case String(kSecAttrType):
                    self = .type(value as! String)
                case String(kSecAttrCreationDate):
                    self = .creationDate(value as! Date)
                case String(kSecAttrModificationDate):
                    self = .modificationDate(value as! Date)
                default:
                    return nil
            }
        }
    }
}

extension [Keychain.Attribute]: SwiftCompatible {}
public extension BaldStudio where T == [Keychain.Attribute] {
    var item: Keychain.ItemType? {
        this.compactMap { if case let .item(value) = $0 { return value } else { return nil } }.first
    }

    var service: String? {
        this.compactMap { if case let .service(value) = $0 { return value } else { return nil } }.first
    }

    var accessible: Keychain.AccessibilityLevel? {
        this.compactMap { if case let .accessible(value) = $0 { return value } else { return nil } }.first
    }

    var accessGroup: String? {
        this.compactMap { if case let .accessGroup(value) = $0 { return value } else { return nil } }.first
    }

    var synchronizable: Bool? {
        this.compactMap { if case let .synchronizable(value) = $0 { return value } else { return nil } }.first
    }

    var server: String? {
        this.compactMap { if case let .server(value) = $0 { return value } else { return nil } }.first
    }

    var port: Int? {
        this.compactMap { if case let .port(value) = $0 { return value } else { return nil } }.first
    }

    var scheme: Keychain.ProtocolType? {
        this.compactMap { if case let .scheme(value) = $0 { return value } else { return nil } }.first
    }

    var authentication: Keychain.AuthenticationType? {
        this.compactMap { if case let .authentication(value) = $0 { return value } else { return nil } }.first
    }

    var securityDomain: String? {
        this.compactMap { if case let .securityDomain(value) = $0 { return value } else { return nil } }.first
    }

    var path: String? {
        this.compactMap { if case let .path(value) = $0 { return value } else { return nil } }.first
    }

    var data: Data? {
        this.compactMap { if case let .data(value) = $0 { return value } else { return nil } }.first
    }

    var account: String? {
        this.compactMap { if case let .account(value) = $0 { return value } else { return nil } }.first
    }

    var label: String? {
        this.compactMap { if case let .label(value) = $0 { return value } else { return nil } }.first
    }

    var comment: String? {
        this.compactMap { if case let .comment(value) = $0 { return value } else { return nil } }.first
    }

    var description: String? {
        this.compactMap { if case let .description(value) = $0 { return value } else { return nil } }.first
    }

    var isInvisible: Bool? {
        this.compactMap { if case let .isInvisible(value) = $0 { return value } else { return nil } }.first
    }

    var isNegative: Bool? {
        this.compactMap { if case let .isNegative(value) = $0 { return value } else { return nil } }.first
    }

    var generic: Data? {
        this.compactMap { if case let .generic(value) = $0 { return value } else { return nil } }.first
    }

    var creator: String? {
        this.compactMap { if case let .creator(value) = $0 { return value } else { return nil } }.first
    }

    var type: String? {
        this.compactMap { if case let .type(value) = $0 { return value } else { return nil } }.first
    }

    var creationDate: Date? {
        this.compactMap { if case let .creationDate(value) = $0 { return value } else { return nil } }.first
    }

    var modificationDate: Date? {
        this.compactMap { if case let .modificationDate(value) = $0 { return value } else { return nil } }.first
    }
}

private extension Bool {
    init?(cfNumber value: CFNumber) {
        if value == kCFBooleanTrue { self = true }
        else if value == kCFBooleanFalse { self = false }
        else { return nil }
    }
}
