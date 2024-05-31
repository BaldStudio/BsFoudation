//
//  KeychainProtocolType.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/31.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

extension Keychain {
    public enum ProtocolType: CustomStringConvertible {
        case ftp
        case ftpAccount
        case http
        case irc
        case nntp
        case pop3
        case smtp
        case socks
        case imap
        case ldap
        case appleTalk
        case afp
        case telnet
        case ssh
        case ftps
        case https
        case httpProxy
        case httpsProxy
        case ftpProxy
        case smb
        case rtsp
        case rtspProxy
        case daap
        case eppc
        case ipp
        case nntps
        case ldaps
        case telnetS
        case imaps
        case ircs
        case pop3S
        
        init?(rawValue: CFString) {
            switch rawValue {
                case kSecAttrProtocolFTP:
                    self = .ftp
                case kSecAttrProtocolFTPAccount:
                    self = .ftpAccount
                case kSecAttrProtocolHTTP:
                    self = .http
                case kSecAttrProtocolIRC:
                    self = .irc
                case kSecAttrProtocolNNTP:
                    self = .nntp
                case kSecAttrProtocolPOP3:
                    self = .pop3
                case kSecAttrProtocolSMTP:
                    self = .smtp
                case kSecAttrProtocolSOCKS:
                    self = .socks
                case kSecAttrProtocolIMAP:
                    self = .imap
                case kSecAttrProtocolLDAP:
                    self = .ldap
                case kSecAttrProtocolAppleTalk:
                    self = .appleTalk
                case kSecAttrProtocolAFP:
                    self = .afp
                case kSecAttrProtocolTelnet:
                    self = .telnet
                case kSecAttrProtocolSSH:
                    self = .ssh
                case kSecAttrProtocolFTPS:
                    self = .ftps
                case kSecAttrProtocolHTTPS:
                    self = .https
                case kSecAttrProtocolHTTPProxy:
                    self = .httpProxy
                case kSecAttrProtocolHTTPSProxy:
                    self = .httpsProxy
                case kSecAttrProtocolFTPProxy:
                    self = .ftpProxy
                case kSecAttrProtocolSMB:
                    self = .smb
                case kSecAttrProtocolRTSP:
                    self = .rtsp
                case kSecAttrProtocolRTSPProxy:
                    self = .rtspProxy
                case kSecAttrProtocolDAAP:
                    self = .daap
                case kSecAttrProtocolEPPC:
                    self = .eppc
                case kSecAttrProtocolIPP:
                    self = .ipp
                case kSecAttrProtocolNNTPS:
                    self = .nntps
                case kSecAttrProtocolLDAPS:
                    self = .ldaps
                case kSecAttrProtocolTelnetS:
                    self = .telnetS
                case kSecAttrProtocolIMAPS:
                    self = .imaps
                case kSecAttrProtocolIRCS:
                    self = .ircs
                case kSecAttrProtocolPOP3S:
                    self = .pop3S
                default:
                    return nil
            }
        }

        var rawValue: String {
            switch self {
                case .ftp:
                    return String(kSecAttrProtocolFTP)
                case .ftpAccount:
                    return String(kSecAttrProtocolFTPAccount)
                case .http:
                    return String(kSecAttrProtocolHTTP)
                case .irc:
                    return String(kSecAttrProtocolIRC)
                case .nntp:
                    return String(kSecAttrProtocolNNTP)
                case .pop3:
                    return String(kSecAttrProtocolPOP3)
                case .smtp:
                    return String(kSecAttrProtocolSMTP)
                case .socks:
                    return String(kSecAttrProtocolSOCKS)
                case .imap:
                    return String(kSecAttrProtocolIMAP)
                case .ldap:
                    return String(kSecAttrProtocolLDAP)
                case .appleTalk:
                    return String(kSecAttrProtocolAppleTalk)
                case .afp:
                    return String(kSecAttrProtocolAFP)
                case .telnet:
                    return String(kSecAttrProtocolTelnet)
                case .ssh:
                    return String(kSecAttrProtocolSSH)
                case .ftps:
                    return String(kSecAttrProtocolFTPS)
                case .https:
                    return String(kSecAttrProtocolHTTPS)
                case .httpProxy:
                    return String(kSecAttrProtocolHTTPProxy)
                case .httpsProxy:
                    return String(kSecAttrProtocolHTTPSProxy)
                case .ftpProxy:
                    return String(kSecAttrProtocolFTPProxy)
                case .smb:
                    return String(kSecAttrProtocolSMB)
                case .rtsp:
                    return String(kSecAttrProtocolRTSP)
                case .rtspProxy:
                    return String(kSecAttrProtocolRTSPProxy)
                case .daap:
                    return String(kSecAttrProtocolDAAP)
                case .eppc:
                    return String(kSecAttrProtocolEPPC)
                case .ipp:
                    return String(kSecAttrProtocolIPP)
                case .nntps:
                    return String(kSecAttrProtocolNNTPS)
                case .ldaps:
                    return String(kSecAttrProtocolLDAPS)
                case .telnetS:
                    return String(kSecAttrProtocolTelnetS)
                case .imaps:
                    return String(kSecAttrProtocolIMAPS)
                case .ircs:
                    return String(kSecAttrProtocolIRCS)
                case .pop3S:
                    return String(kSecAttrProtocolPOP3S)
            }
        }

        public var description: String {
            switch self {
                case .ftp:
                    return "FTP"
                case .ftpAccount:
                    return "FTPAccount"
                case .http:
                    return "HTTP"
                case .irc:
                    return "IRC"
                case .nntp:
                    return "NNTP"
                case .pop3:
                    return "POP3"
                case .smtp:
                    return "SMTP"
                case .socks:
                    return "SOCKS"
                case .imap:
                    return "IMAP"
                case .ldap:
                    return "LDAP"
                case .appleTalk:
                    return "AppleTalk"
                case .afp:
                    return "AFP"
                case .telnet:
                    return "Telnet"
                case .ssh:
                    return "SSH"
                case .ftps:
                    return "FTPS"
                case .https:
                    return "HTTPS"
                case .httpProxy:
                    return "HTTPProxy"
                case .httpsProxy:
                    return "HTTPSProxy"
                case .ftpProxy:
                    return "FTPProxy"
                case .smb:
                    return "SMB"
                case .rtsp:
                    return "RTSP"
                case .rtspProxy:
                    return "RTSPProxy"
                case .daap:
                    return "DAAP"
                case .eppc:
                    return "EPPC"
                case .ipp:
                    return "IPP"
                case .nntps:
                    return "NNTPS"
                case .ldaps:
                    return "LDAPS"
                case .telnetS:
                    return "TelnetS"
                case .imaps:
                    return "IMAPS"
                case .ircs:
                    return "IRCS"
                case .pop3S:
                    return "POP3S"
            }
        }
    }
}


