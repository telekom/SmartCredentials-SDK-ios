//
//  SetAccessRightsCommand.swift
//  Core
//
//  Created by Camelia Ignat on 28.10.2021.
//  Copyright © 2021 Andrei Moldovan. All rights reserved.
//

import Foundation

public class SetAccessRightsCommand: Command {
    let chat: [String]
    
    private enum CodingKeys : String, CodingKey {
        case chat
    }
    
    public init(cmd: String, chat: [String]) {
        self.chat = chat
        super.init(cmd: cmd)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        chat = try container.decode([String].self, forKey: .chat)
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(chat, forKey: .chat)
    }
}
