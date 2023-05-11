//
//  URLExtension.swift
//  IdentityProvider
//
//  Created by Camelia Ignat on 11.05.2023.
//

import Foundation

extension URL {

    func appending(_ queryItem: String, value: String?) -> URL {
        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }

        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []

        let queryItem = URLQueryItem(name: queryItem, value: value)
        queryItems.append(queryItem)
        
        urlComponents.queryItems = queryItems

        return urlComponents.url!
    }
}
