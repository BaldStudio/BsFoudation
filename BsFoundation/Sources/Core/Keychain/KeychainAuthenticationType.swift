//
//  KeychainAuthenticationType.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/31.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

extension Keychain {
    public enum AuthenticationType: CustomStringConvertible {
        case `default`
        case ntlm
        case msn
        case dpa
        case rpa
        case httpBasic
        case httpDigest
        case htmlForm
        
        init?(rawValue: CFString) {
            switch rawValue {
                case kSecAttrAuthenticationTypeNTLM:
                    self = .ntlm
                case kSecAttrAuthenticationTypeMSN:
                    self = .msn
                case kSecAttrAuthenticationTypeDPA:
                    self = .dpa
                case kSecAttrAuthenticationTypeRPA:
                    self = .rpa
                case kSecAttrAuthenticationTypeHTTPBasic:
                    self = .httpBasic
                case kSecAttrAuthenticationTypeHTTPDigest:
                    self = .httpDigest
                case kSecAttrAuthenticationTypeHTMLForm:
                    self = .htmlForm
                case kSecAttrAuthenticationTypeDefault:
                    self = .`default`
                default:
                    return nil
            }
        }

        var rawValue: String {
            switch self {
                case .ntlm:
                    return String(kSecAttrAuthenticationTypeNTLM)
                case .msn:
                    return String(kSecAttrAuthenticationTypeMSN)
                case .dpa:
                    return String(kSecAttrAuthenticationTypeDPA)
                case .rpa:
                    return String(kSecAttrAuthenticationTypeRPA)
                case .httpBasic:
                    return String(kSecAttrAuthenticationTypeHTTPBasic)
                case .httpDigest:
                    return String(kSecAttrAuthenticationTypeHTTPDigest)
                case .htmlForm:
                    return String(kSecAttrAuthenticationTypeHTMLForm)
                case .`default`:
                    return String(kSecAttrAuthenticationTypeDefault)
            }
        }

        public var description: String {
            switch self {
                case .`default`:
                    return "Default"
                case .ntlm:
                    return "NTLM"
                case .msn:
                    return "MSN"
                case .dpa:
                    return "DPA"
                case .rpa:
                    return "RPA"
                case .httpBasic:
                    return "HTTPBasic"
                case .httpDigest:
                    return "HTTPDigest"
                case .htmlForm:
                    return "HTMLForm"
            }
        }
    }
}

