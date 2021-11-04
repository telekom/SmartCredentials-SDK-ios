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
        error = try container.decodeIfPresent(String.self, forKey: .error)
        aux = try container.decodeIfPresent(AuxInfo.self, forKey: .aux)
        chat = try container.decode(ChatInfo.self, forKey: .chat)
        canAllowed = try container.decodeIfPresent(Bool.self, forKey: .canAllowed)
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

public class AuxInfo: Codable {
    public let ageVerificationDate: String?
    public let requiredAge: String?
    public let validityDate: String?
    public let communityId: String?
    
    private enum CodingKeys : String, CodingKey {
        case ageVerificationDate
        case requiredAge
        case validityDate
        case communityId
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        ageVerificationDate = try container.decodeIfPresent(String.self, forKey: .ageVerificationDate)
        requiredAge = try container.decodeIfPresent(String.self, forKey: .requiredAge)
        validityDate = try container.decodeIfPresent(String.self, forKey: .validityDate)
        communityId = try container.decodeIfPresent(String.self, forKey: .communityId)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(ageVerificationDate, forKey: .ageVerificationDate)
        try container.encode(requiredAge, forKey: .requiredAge)
        try container.encode(validityDate, forKey: .validityDate)
        try container.encode(communityId, forKey: .communityId)
    }
}

public class ChatInfo: Codable {
    public let effective: [String]
    public let optional: [String]
    public let required: [String]
    
    private enum CodingKeys : String, CodingKey {
        case effective
        case optional
        case required
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        effective = try container.decode([String].self, forKey: .effective)
        optional = try container.decode([String].self, forKey: .optional)
        required = try container.decode([String].self, forKey: .required)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(effective, forKey: .effective)
        try container.encode(optional, forKey: .optional)
        try container.encode(required, forKey: .required)
    }
}
