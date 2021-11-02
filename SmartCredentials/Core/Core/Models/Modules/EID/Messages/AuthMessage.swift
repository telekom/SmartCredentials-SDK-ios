//
//  AuthMessage.swift
//  Core
//
//  Created by Camelia Ignat on 28.10.2021.
//  Copyright © 2021 Andrei Moldovan. All rights reserved.
//

import Foundation

public class AuthMessage: Message {
    public let error: String?
    public let result: AuthResult?
    public let url: String?
    
    private enum CodingKeys : String, CodingKey {
        case error
        case result
        case url
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        error = try container.decode(String.self, forKey: .error)
        result = try container.decode(AuthResult.self, forKey: .result)
        url = try container.decode(String.self, forKey: .url)
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(error, forKey: .error)
        try container.encode(result, forKey: .result)
        try container.encode(url, forKey: .url)
    }
}

public struct AuthResult: Codable {
    public let major: String?
    public let minor: String?
    public let language: String?
    public let description: String?
    public let message: String?
}
