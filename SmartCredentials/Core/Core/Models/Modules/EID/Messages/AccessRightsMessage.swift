//
//  AccessRightsMessage.swift
//  Core
//
//  Created by Camelia Ignat on 28.10.2021.
//  Copyright © 2021 Andrei Moldovan. All rights reserved.
//

import Foundation

class AccessRightsMessage: Message {
    let error: String?
    let aux: AuxInfo?
    let chat: ChatInfo
    let canAllowed: Bool?
    
    private enum CodingKeys : String, CodingKey {
        case error
        case aux
        case chat
        case canAllowed
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        error = try container.decode(String.self, forKey: .error)
        aux = try container.decode(AuxInfo.self, forKey: .aux)
        chat = try container.decode(ChatInfo.self, forKey: .chat)
        canAllowed = try container.decode(Bool.self, forKey: .canAllowed)
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(error, forKey: .error)
        try container.encode(aux, forKey: .aux)
        try container.encode(chat, forKey: .chat)
        try container.encode(canAllowed, forKey: .canAllowed)
    }
}

struct AuxInfo: Codable {
    let ageVerificationDate: String?
    let requiredAge: String?
    let validityDate: String?
    let communityId: String?
}

struct ChatInfo: Codable {
    let effective: [String]
    let optional: [String]
    let required: [String]
}
