//
//  ReaderMessage.swift
//  Core
//
//  Created by Camelia Ignat on 28.10.2021.
//  Copyright © 2021 Andrei Moldovan. All rights reserved.
//

import Foundation

class ReaderMessage: Message {
    let name: String
    let attached: Bool
    let keypad: Bool
    let card: CardMessage?
    
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
        card = try container.decode(CardMessage.self, forKey: .card)
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(attached, forKey: .attached)
        try container.encode(keypad, forKey: .keypad)
        try container.encode(card, forKey: .card)
    }
}

struct CardMessage: Codable {
    let inoperative: Bool
    let deactivated: Bool
    let retryCounter: Int
}
