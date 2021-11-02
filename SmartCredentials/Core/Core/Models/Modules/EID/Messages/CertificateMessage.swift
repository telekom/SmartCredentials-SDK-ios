//
//  CertificateMessage.swift
//  Core
//
//  Created by Camelia Ignat on 28.10.2021.
//  Copyright © 2021 Andrei Moldovan. All rights reserved.
//

import Foundation

public class CertificateMessage: Message {
    public let description: CertificateDescription
    public let validity: CertificateValidity
    
    private enum CodingKeys : String, CodingKey {
        case description
        case validity
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        description = try container.decode(CertificateDescription.self, forKey: .description)
        validity = try container.decode(CertificateValidity.self, forKey: .validity)
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(description, forKey: .description)
        try container.encode(validity, forKey: .validity)
    }
}

public struct CertificateDescription: Codable {
    public let issuerName: String
    public let issuerUrl: String
    public let subjectName: String
    public let subjectUrl: String
    public let termsOfUsage: String
    public let purpose: String
}

public struct CertificateValidity: Codable {
    public let effectiveDate: String
    public let expirationDate: String
}
