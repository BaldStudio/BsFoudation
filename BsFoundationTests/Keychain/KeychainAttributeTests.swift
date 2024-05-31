//
//  KeychainAttributeTests.swift
//  BsFoundationTests
//
//  Created by Runze Chang on 2024/5/31.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

@testable import BsFoundation

class AttributeTests: XCTestCase {
    func testKeychainAttributeElemet() {
        do {
            let attribute = Keychain.Attribute.item(.genericPassword)
            XCTAssertEqual(attribute.element.key, kSecClass)
            XCTAssertEqual(attribute.element.value as! CFString, Keychain.ItemType.genericPassword.rawValue)
        }

        do {
            let attribute = Keychain.Attribute.item(.internetPassword)
            XCTAssertEqual(attribute.element.key, kSecClass)
            XCTAssertEqual(attribute.element.value as! CFString, Keychain.ItemType.internetPassword.rawValue)
        }
    }

    func testKeychainCreationDateAttribute() {
        let date = Date()

        do {
            let attribute = Keychain.Attribute.creationDate(date)
            XCTAssertEqual(attribute.element.key, kSecAttrCreationDate)
            XCTAssertEqual(attribute.element.value as! Date, date)
            XCTAssertEqual([attribute].bs.creationDate, date)
        }

        do {
            let attribute = Keychain.Attribute(key: String(kSecAttrCreationDate), value: date)!
            XCTAssertEqual(attribute.element.key, kSecAttrCreationDate)
            XCTAssertEqual(attribute.element.value as! Date, date)
            XCTAssertEqual([attribute].bs.creationDate, date)
        }
    }

    func testKeychainModificatioDateAttribute() {
        let date = Date()

        do {
            let attribute = Keychain.Attribute.modificationDate(date)
            XCTAssertEqual(attribute.element.key, kSecAttrModificationDate)
            XCTAssertEqual(attribute.element.value as! Date, date)
            XCTAssertEqual([attribute].bs.modificationDate, date)
        }

        do {
            let attribute = Keychain.Attribute(key: String(kSecAttrModificationDate), value: date)!
            XCTAssertEqual(attribute.element.key, kSecAttrModificationDate)
            XCTAssertEqual(attribute.element.value as! Date, date)
            XCTAssertEqual([attribute].bs.modificationDate, date)
        }
    }

    func testKeychainAttributeInitializer() {
        XCTAssertEqual(
            Keychain.Attribute(key: String(kSecClass), value: Keychain.ItemType.genericPassword.rawValue),
            Keychain.Attribute.item(.genericPassword)
        )
        XCTAssertEqual(
            Keychain.Attribute(key: String(kSecClass), value: Keychain.ItemType.internetPassword.rawValue),
            Keychain.Attribute.item(.internetPassword)
        )
    }
}

