//
//  JSON.swift
//  BsFoundation
//
//  Created by 常润泽 on 2024/2/1.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

typealias JSONObject = [String: JSONValue]

extension CodingUserInfoKey {
    static let codable = CodingUserInfoKey(rawValue: "codable")!
}

public protocol JSONCodable: Codable {
    /// 转换方法，支持 Data，JSON String、Dictionary、Array
    static func decode(with json: Any) throws -> Self
    
    /// 自定义键值映射
    static var customPropertyMapper: [String: JSONCodableMapperValue] { get }
    
    /// 指定key对应属性的默认值
    static func defaultValue<CodingKeys: CodingKey>(for key: CodingKeys) -> Any?
    
    /// 转换前做数据处理，如将深层的数据拍扁等
    static func customTransform(with jsonObject: Any, decoder: Decoder) throws -> Bool
}

public extension JSONCodable {
    static func decode(with json: Any) throws -> Self {
        let jsonValue: JSONValue
        do {
            if let data = json as? Data {
                jsonValue = try _JSONParser.parse(data)
            } else if let string = json as? String {
                jsonValue = try _JSONParser.parse(string)
            } else {
                let data = try JSONSerialization.data(withJSONObject: json)
                jsonValue = try _JSONParser.parse(data)
            }
        } catch {
            throw DecodingError.dataCorrupted(.init(codingPath: [],
                                                    debugDescription: "The given json was not valid",
                                                    underlyingError: error))
        }
        let decoder = _JSONDecoder(referencing: jsonValue)
        guard try customTransform(with: jsonValue, decoder: decoder) else {
            throw error(.interruptByUser)
        }
        decoder.userInfo[.codable] = self
        return try decoder.unbox(object: jsonValue)
    }

    static func defaultValue<CodingKeys: CodingKey>(for key: CodingKeys) -> Any? { nil }

    static var customPropertyMapper: [String: JSONCodableMapperValue] { [:] }

    static func customTransform(with jsonObject: Any, decoder: Decoder) throws -> Bool { true }
}

extension Array: JSONCodable where Element: JSONCodable {}

// MARK: - Property Wrapper

// TODO: 还没好呢，下面的不要用

protocol CodingValueRepresentable {
    
}

@propertyWrapper
final class CodingValue<Value: JSONValueConvertible>: Codable, CodingValueRepresentable {
    typealias WrapperValue = Value
    private var keys: [String]?
    private var storageValue: Value?
        
    var wrappedValue: Value {
        get { storageValue ?? Value.defaultValue }
        set { storageValue = newValue }
    }
    
    deinit {
        logger.debug("CodingValue deinit")
    }
    
    init(from decoder: Decoder) throws {
        logger.debug("decoder")
    }
    
    func encode(to encoder: Encoder) throws {}
    
    init(storageValue: Value? = nil, keys: [String]? = nil) {
        logger.debug("init")
        self.storageValue = storageValue
        self.keys = keys
    }

    convenience init(wrappedValue: Value) {
        self.init(storageValue: wrappedValue)
    }
    
    convenience init(wrappedValue: Value, keys: String...) {
        self.init(storageValue: wrappedValue, keys: keys)
    }

    convenience init(keys: String...) {
        self.init(keys: keys)
    }
}

