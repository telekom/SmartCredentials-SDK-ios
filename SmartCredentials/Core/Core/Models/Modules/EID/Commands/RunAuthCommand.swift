//
//  RunAuthCommand.swift
//  Core
//
//  Created by Camelia Ignat on 28.10.2021.
//  Copyright © 2021 Andrei Moldovan. All rights reserved.
//

import Foundation

class RunAuthCommand: Command {
    let tcTokenURL: String
    let handleInterrupt: Bool
    let messages: CommandMessages?
    
    private enum CodingKeys : String, CodingKey {
        case tcTokenURL
        case handleInterrupt
        case messages
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        tcTokenURL = try container.decode(String.self, forKey: .tcTokenURL)
        handleInterrupt = try container.decode(Bool.self, forKey: .handleInterrupt)
        messages = try container.decode(CommandMessages.self, forKey: .messages)
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(tcTokenURL, forKey: .tcTokenURL)
        try container.encode(handleInterrupt, forKey: .handleInterrupt)
        try container.encode(messages, forKey: .messages)
    }
}

struct CommandMessages: Codable {
    let sessionStarted: String
    let sessionFailed: String
    let sessionSucceeded: String
    let sessionInProgress: String
}
