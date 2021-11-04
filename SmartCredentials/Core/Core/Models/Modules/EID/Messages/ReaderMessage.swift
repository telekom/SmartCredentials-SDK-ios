//
//  ReaderMessage.swift
//  Core
//
//  Created by Camelia Ignat on 28.10.2021.
//  Copyright © 2021 Andrei Moldovan. All rights reserved.
//

import Foundation

public class ReaderMessage: Message {
    public let name: String
    public let attached: Bool
    public let keypad: Bool
    public let card: CardMessage?
    
    private enum CodingKeys : String, CodingKey {
        case name
        case attached
        case keypad
        case card
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        attached = try container.decode(Bool.self, forKey: .attached)
        keypad = try container.decode(Bool.self, forKey: .keypad)
        card = try container.decodeIfPresent(CardMessage.self, forKey: .card)
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(attached, forKey: .attached)
        try container.encode(keypad, forKey: .keypad)
        try container.encode(card, forKey: .card)
    }
}

public struct CardMessage: Codable {
    public let inoperative: Bool
    public let deactivated: Bool
    public let retryCounter: Int
}
