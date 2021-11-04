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
        
        error = try container.decodeIfPresent(String.self, forKey: .error)
        result = try container.decodeIfPresent(AuthResult.self, forKey: .result)
        url = try container.decodeIfPresent(String.self, forKey: .url)
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

public class AuthResult: Codable {
    public let major: String?
    public let minor: String?
    public let language: String?
    public let description: String?
    public let message: String?
    
    private enum CodingKeys : String, CodingKey {
        case major
        case minor
        case language
        case description
        case message
    }
    
    public init(major: String?, minor: String?, language: String?, description: String?, message: String?) {
        self.major = major
        self.minor = minor
        self.language = language
        self.description = description
        self.message = message
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        major = try container.decodeIfPresent(String.self, forKey: .major)
        minor = try container.decodeIfPresent(String.self, forKey: .minor)
        language = try container.decodeIfPresent(String.self, forKey: .language)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        message = try container.decodeIfPresent(String.self, forKey: .message)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(major, forKey: .major)
        try container.encode(minor, forKey: .minor)
        try container.encode(language, forKey: .language)
        try container.encode(description, forKey: .description)
        try container.encode(message, forKey: .message)
    }
}
