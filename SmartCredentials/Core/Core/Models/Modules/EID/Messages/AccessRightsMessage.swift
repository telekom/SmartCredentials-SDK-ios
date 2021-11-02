//
//  AccessRightsMessage.swift
//  Core
//
//  Created by Camelia Ignat on 28.10.2021.
//  Copyright © 2021 Andrei Moldovan. All rights reserved.
//

import Foundation

public class AccessRightsMessage: Message {
    public let error: String?
    public let aux: AuxInfo?
    public let chat: ChatInfo
    public let canAllowed: Bool?
    
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
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(error, forKey: .error)
        try container.encode(aux, forKey: .aux)
        try container.encode(chat, forKey: .chat)
        try container.encode(canAllowed, forKey: .canAllowed)
    }
}

public struct AuxInfo: Codable {
    public let ageVerificationDate: String?
    public let requiredAge: String?
    public let validityDate: String?
    public let communityId: String?
}

public struct ChatInfo: Codable {
    public let effective: [String]
    public let optional: [String]
    public let required: [String]
}
