//
//  ChangePINMessage.swift
//  Core
//
//  Created by Camelia Ignat on 28.10.2021.
//  Copyright © 2021 Andrei Moldovan. All rights reserved.
//

import Foundation

public class ChangePINMessage: Message {
    public let success: Bool?
    public let reason: String?
    
    private enum CodingKeys : String, CodingKey {
        case success
        case reason
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        success = try container.decodeIfPresent(Bool.self, forKey: .success)
        reason = try container.decodeIfPresent(String.self, forKey: .reason)
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(success, forKey: .success)
        try container.encodeIfPresent(reason, forKey: .reason)
    }
}
