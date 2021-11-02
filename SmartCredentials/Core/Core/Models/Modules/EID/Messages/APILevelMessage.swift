//
//  APILevelMessage.swift
//  Core
//
//  Created by Camelia Ignat on 28.10.2021.
//  Copyright © 2021 Andrei Moldovan. All rights reserved.
//

import Foundation

public class APILevelMessage: Message {
    public let error: String?
    public let available: [Int]
    public let current: Int
    
    private enum CodingKeys : String, CodingKey {
        case error
        case available
        case current
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        error = try container.decode(String.self, forKey: .error)
        available = try container.decode([Int].self, forKey: .available)
        current = try container.decode(Int.self, forKey: .current)
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(error, forKey: .error)
        try container.encode(available, forKey: .available)
        try container.encode(current, forKey: .current)
    }
}
