//
//  CertificateMessage.swift
//  Core
//
//  Created by Camelia Ignat on 28.10.2021.
//  Copyright © 2021 Andrei Moldovan. All rights reserved.
//

import Foundation

class CertificateMessage: Message {
    let description: CertificateDescription
    let validity: CertificateValidity
    
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
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(description, forKey: .description)
        try container.encode(validity, forKey: .validity)
    }
}

struct CertificateDescription: Codable {
    let issuerName: String
    let issuerUrl: String
    let subjectName: String
    let subjectUrl: String
    let termsOfUsage: String
    let purpose: String
}

struct CertificateValidity: Codable {
    let effectiveDate: String
    let expirationDate: String
}
