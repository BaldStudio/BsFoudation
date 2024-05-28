//
//  URL+.swift
//  BsFoundation
//
//  Created by Runze Chang on 2024/5/16.
//  Copyright © 2024 BaldStudio. All rights reserved.
//

public extension URL {
    var queryParameters: [String: String] {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            return .empty
        }
    
        var items: [String: String] = .empty
        for queryItem in queryItems {
            items[queryItem.name] = queryItem.value
        }
        return items
    }
    
    mutating func appendQueryParameters(_ parameters: [String: String]) {
        self = appendingQueryParameters(parameters)
    }
    
    func appendingQueryParameters(_ parameters: [String: String]) -> URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return self
        }
        
        var items = components.queryItems ?? []
        items += parameters.map({ URLQueryItem(name: $0, value: $1) })
        components.queryItems = items
        return components.url!
    }
    
    func queryValue(for key: String) -> String? {
        guard let items = URLComponents(string: absoluteString)?.queryItems else { return nil }
        for item in items where item.name == key {
            return item.value
        }
        return nil
    }
}
