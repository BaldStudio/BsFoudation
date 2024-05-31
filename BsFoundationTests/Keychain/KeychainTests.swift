//
//  KeychainTests.swift
//  BsFoundationTests
//
//  Created by Runze Chang on 2024/5/31.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

@testable import BsFoundation

class KeychainTests: XCTestCase {
    override func setUp() {
        super.setUp()
        do { try Keychain().deleteAll() } catch {}
        do { try Keychain(accessGroup: "com.baldstudio.keychain.tests").deleteAll() } catch {}
    }
    
    // MARK: - Initializers

    func testInitializer() {
        do {
            let keychain = Keychain()
            XCTAssertNil(keychain.accessGroup)
        }

        do {
            let keychain = Keychain(accessGroup: "com.baldstudio.keychain.tests")
            XCTAssertEqual(keychain.accessGroup, "com.baldstudio.keychain.tests")
        }
    }
    
    func testGetAttributesForGenericPasswordWithDefaultInitilisers() throws {
        let keychain = Keychain()
        let key = Keychain.Key<String>(key: "key", service: "com.baldstudio.keychain")

        try? keychain.set("value", for: key)
        let attributes = try keychain.attributes(for: key)
        XCTAssertEqual(attributes.bs.item, .genericPassword)
        XCTAssertEqual(attributes.bs.service, "com.baldstudio.keychain")
        XCTAssertEqual(attributes.bs.accessible, .whenUnlocked)
        XCTAssertEqual(attributes.bs.synchronizable, false)
        XCTAssertEqual(attributes.bs.accessGroup, "Y64ARVLCP4.com.baldstudio.BsFoundationDemo")
        XCTAssertNil(attributes.bs.label)
        XCTAssertNil(attributes.bs.comment)
        XCTAssertNil(attributes.bs.description)
        XCTAssertNil(attributes.bs.isInvisible)
        XCTAssertNil(attributes.bs.isNegative)
        XCTAssertNil(attributes.bs.generic)
        XCTAssertNotNil(attributes.bs.creationDate)
        XCTAssertNotNil(attributes.bs.modificationDate)
    }

    func testGetAttributesForGenericPassword() throws {
        let keychain = Keychain(
            accessGroup: "group.com.baldstudio.keychain.tests"
        )
        let key = Keychain.Key<String>(
            key: "key",
            service: "com.baldstudio.keychain",
            accessible: .whenUnlocked,
            label: "label",
            comment: "comment",
            description: "description",
            isInvisible: true,
            isNegative: false,
            generic: "generic".data(using: .utf8)!,
            creator: "key creator",
            type: "key type"
        )

        try keychain.set("value", for: key)
        let attributes = try keychain.attributes(for: key)

        XCTAssertEqual(attributes.bs.item, .genericPassword)
        XCTAssertEqual(attributes.bs.service, "com.baldstudio.keychain")
        XCTAssertEqual(attributes.bs.accessible, .whenUnlocked)
        XCTAssertEqual(attributes.bs.synchronizable, false)
        XCTAssertEqual(attributes.bs.label, "label")
        XCTAssertEqual(attributes.bs.comment, "comment")
        XCTAssertEqual(attributes.bs.description, "description")
        XCTAssertEqual(attributes.bs.isInvisible, true)
        XCTAssertEqual(attributes.bs.isNegative, false)
        XCTAssertEqual(attributes.bs.generic, "generic".data(using: .utf8)!)
        XCTAssertEqual(attributes.bs.accessGroup, "group.com.baldstudio.keychain.tests")
        XCTAssertEqual(attributes.bs.creator, "key creator")
        XCTAssertEqual(attributes.bs.type, "key type")
        XCTAssertNotNil(attributes.bs.creationDate)
        XCTAssertNotNil(attributes.bs.modificationDate)
    }

    func testGetAttributesForInternetPasswordWithDefaultInitilisers() throws {
        let keychain = Keychain()
        let key = Keychain.Key<String>(
            key: "key",
            url: URL(string: "https://github.com:8080/BsFoundation")!,
            scheme: .https,
            authentication: .httpBasic
        )

        try keychain.set("value", for: key)
        let attributes = try keychain.attributes(for: key)

        XCTAssertEqual(attributes.bs.item, .internetPassword)
        XCTAssertEqual(attributes.bs.server, "github.com")
        XCTAssertEqual(attributes.bs.scheme, .https)
        XCTAssertEqual(attributes.bs.port, 8080)
        XCTAssertEqual(attributes.bs.path, "/BsFoundation")
        XCTAssertEqual(attributes.bs.authentication, .httpBasic)
        XCTAssertEqual(attributes.bs.accessible, .whenUnlocked)
        XCTAssertEqual(attributes.bs.synchronizable, false)
        XCTAssertEqual(attributes.bs.securityDomain, "")
        XCTAssertNil(attributes.bs.label)
        XCTAssertNil(attributes.bs.comment)
        XCTAssertNil(attributes.bs.description)
        XCTAssertNil(attributes.bs.isInvisible)
        XCTAssertNil(attributes.bs.isNegative)
        XCTAssertEqual(attributes.bs.accessGroup, "Y64ARVLCP4.com.baldstudio.BsFoundationDemo")
        XCTAssertNotNil(attributes.bs.creationDate)
        XCTAssertNotNil(attributes.bs.modificationDate)

        // Check General password specific attributes
        XCTAssertNil(attributes.bs.generic)
    }

    func testGetInternetPasswordAttributes() throws {
        let keychain = Keychain(
            accessGroup: "group.com.baldstudio.keychain.tests"
        )
        let key = Keychain.Key<String>(
            key: "key",
            accessible: .afterFirstUnlock,
            synchronizable: true,
            url: URL(string: "https://github.com:8080/BsFoundation")!,
            scheme: .https,
            authentication: .httpBasic,
            securityDomain: "securityDomain",
            label: "label",
            comment: "comment",
            description: "description",
            isInvisible: true,
            isNegative: false,
            creator: "key creator",
            type: "key type"
        )

        try keychain.set("value", for: key)
        let attributes = try keychain.attributes(for: key)

        XCTAssertEqual(attributes.bs.item, .internetPassword)
        XCTAssertEqual(attributes.bs.server, "github.com")
        XCTAssertEqual(attributes.bs.scheme, .https)
        XCTAssertEqual(attributes.bs.port, 8080)
        XCTAssertEqual(attributes.bs.path, "/BsFoundation")
        XCTAssertEqual(attributes.bs.authentication, .httpBasic)
        XCTAssertEqual(attributes.bs.accessible, .afterFirstUnlock)
        XCTAssertEqual(attributes.bs.synchronizable, true)
        XCTAssertEqual(attributes.bs.securityDomain, "securityDomain")
        XCTAssertEqual(attributes.bs.label, "label")
        XCTAssertEqual(attributes.bs.comment, "comment")
        XCTAssertEqual(attributes.bs.description, "description")
        XCTAssertEqual(attributes.bs.isInvisible, true)
        XCTAssertEqual(attributes.bs.isNegative, false)
        XCTAssertEqual(attributes.bs.accessGroup, "group.com.baldstudio.keychain.tests")
        XCTAssertEqual(attributes.bs.creator, "key creator")
        XCTAssertEqual(attributes.bs.type, "key type")
        XCTAssertNotNil(attributes.bs.creationDate)
        XCTAssertNotNil(attributes.bs.modificationDate)

        // Check General password specific attributes
        XCTAssertNil(attributes.bs.generic)
    }

}
