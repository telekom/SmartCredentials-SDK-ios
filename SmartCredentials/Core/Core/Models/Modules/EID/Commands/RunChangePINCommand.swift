//
//  RunChangePINCommand.swift
//  Core
//
//  Created by Camelia Ignat on 28.10.2021.
//  Copyright © 2021 Andrei Moldovan. All rights reserved.
//

import Foundation

public class RunChangePINCommand: Command {
    public let handleInterrupt: Bool
    public let messages: CommandMessages?
    
    private enum CodingKeys : String, CodingKey {
        case handleInterrupt
        case messages
    }
    
    public init(cmd: String, handleInterrupt: Bool, messages: CommandMessages?) {
        self.handleInterrupt = handleInterrupt
        self.messages = messages
        super.init(cmd: cmd)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        handleInterrupt = try container.decode(Bool.self, forKey: .handleInterrupt)
        messages = try container.decode(CommandMessages.self, forKey: .messages)
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(handleInterrupt, forKey: .handleInterrupt)
        try container.encode(messages, forKey: .messages)
    }
}
