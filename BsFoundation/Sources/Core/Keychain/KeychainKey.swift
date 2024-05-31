//
//  KeychainKeys.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/31.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

extension Keychain {
    public enum Key<T: KeychainSerializable> {
        case genericPassword(GenericPassword)
        case internetPassword(InternetPassword)
                
        public init(
            key: String,
            service: String,
            accessible: AccessibilityLevel = .whenUnlocked,
            synchronizable: Bool = false,
            label: String? = nil,
            comment: String? = nil,
            description: String? = nil,
            isInvisible: Bool? = nil,
            isNegative: Bool? = nil,
            generic: Data? = nil,
            creator: String? = nil,
            type: String? = nil
        ) {
            self = .genericPassword(
                .init(
                    key: key,
                    service: service,
                    accessible: accessible,
                    synchronizable: synchronizable,
                    label: label,
                    comment: comment,
                    description: description,
                    isInvisible: isInvisible,
                    isNegative: isNegative,
                    generic: generic,
                    creator: creator,
                    type: type
                )
            )
        }

        /// url - must containse host and correct scheme, othervise will generate run-time error
        public init(
            key: String,
            accessible: AccessibilityLevel = .whenUnlocked,
            synchronizable: Bool = false,
            url: URL,
            scheme: ProtocolType,
            authentication: AuthenticationType,
            securityDomain: String? = nil,
            label: String? = nil,
            comment: String? = nil,
            description: String? = nil,
            isInvisible: Bool? = nil,
            isNegative: Bool? = nil,
            creator: String? = nil,
            type: String? = nil
        ) {
            self = .internetPassword(
                .init(
                    key: key,
                    accessible: accessible,
                    synchronizable: synchronizable,
                    url: url,
                    scheme: scheme,
                    authentication: authentication,
                    securityDomain: securityDomain,
                    label: label,
                    comment: comment,
                    description: description,
                    isInvisible: isInvisible,
                    isNegative: isNegative,
                    creator: creator,
                    type: type
                )
            )
        }
        
        public var key: String {
            switch self {
                case .genericPassword(let attrs):
                    return attrs.key
                case .internetPassword(let attrs):
                    return attrs.key
            }
        }

        public var accessible: AccessibilityLevel {
            switch self {
                case .genericPassword(let attrs):
                    return attrs.accessible
                case .internetPassword(let attrs):
                    return attrs.accessible
            }
        }

        public var synchronizable: Bool {
            switch self {
                case .genericPassword(let attrs):
                    return attrs.synchronizable
                case .internetPassword(let attrs):
                    return attrs.synchronizable
            }
        }

        public var label: String? {
            switch self {
                case .genericPassword(let attrs):
                    return attrs.label
                case .internetPassword(let attrs):
                    return attrs.label
            }
        }

        public var comment: String? {
            switch self {
                case .genericPassword(let attrs):
                    return attrs.comment
                case .internetPassword(let attrs):
                    return attrs.comment
            }
        }

        public var description: String? {
            switch self {
                case .genericPassword(let attrs):
                    return attrs.description
                case .internetPassword(let attrs):
                    return attrs.description
            }
        }

        public var isInvisible: Bool? {
            switch self {
                case .genericPassword(let attrs):
                    return attrs.isInvisible
                case .internetPassword(let attrs):
                    return attrs.isInvisible
            }
        }

        public var isNegative: Bool? {
            switch self {
                case .genericPassword(let attrs):
                    return attrs.isNegative
                case .internetPassword(let attrs):
                    return attrs.isNegative
            }
        }

        // TODO: We can set and get String for this property, but according to spec we should use CFNumberRef.
        public var creator: String? {
            switch self {
                case .genericPassword(let attrs):
                    return attrs.creator
                case .internetPassword(let attrs):
                    return attrs.creator
            }
        }

        // TODO: We can set and get String for this property, but according to spec we should use CFNumberRef.
        public var type: String? {
            switch self {
                case .genericPassword(let attrs):
                    return attrs.type
                case .internetPassword(let attrs):
                    return attrs.type
            }
        }
    }
}

extension Keychain.Key {
    var queryAttributes: AnyAttributes {
        typealias Attribute = Keychain.Attribute
        
        var attributes = AnyAttributes()
        attributes.append(Attribute.SynchronizableAny())
        switch self {
            case .genericPassword(let attr):
                attributes.append(Attribute.item(.genericPassword))
                attributes.append(Attribute.service(attr.service))
            case .internetPassword(let attr):
                attributes.append(Attribute.item(.internetPassword))

                // TODO: Replace fatal error with throws error
                if #available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *) {
                    guard let host = attr.url.host(percentEncoded: true) else {
                        fatalError("Missing `host` information in provided URL")
                    }
                    attributes.append(Attribute.server(host))
                } else {
                    guard let host = attr.url.host else { fatalError("Missing host information in provided URL") }
                    attributes.append(Attribute.server(host))
                }

                attributes.append(Attribute.scheme(attr.scheme))
                attributes.append(Attribute.path(attr.url.path))
                attr.url.port.flatMap { attributes.append(Attribute.port($0)) }

                // TODO: Invetigate do we really reaquire AuthenticationType on internet password
                attributes.append(Attribute.authentication(attr.authentication))

                if let securityDomain = attr.securityDomain {
                    attributes.append(Attribute.securityDomain(securityDomain))
                }
        }
        return attributes
    }
    
    var updateRequestAttributes: AnyAttributes {
        var attributes = [Keychain.Attribute]()
        attributes.append(.accessible(accessible))
        attributes.append(.synchronizable(synchronizable))

        label.flatMap { attributes.append(.label($0)) }
        comment.flatMap { attributes.append(.comment($0)) }
        description.flatMap { attributes.append(.description($0)) }
        isInvisible.flatMap { attributes.append(.isInvisible($0)) }
        isNegative.flatMap { attributes.append(.isNegative($0)) }
        creator.flatMap { attributes.append(.creator($0)) }
        type.flatMap { attributes.append(.type($0)) }
        if case let .genericPassword(attrs) = self,
           let generic = attrs.generic {
            attributes.append(.generic(generic))
        }
        return attributes
    }
}
