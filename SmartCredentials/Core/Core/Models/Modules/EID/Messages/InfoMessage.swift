//
//  InfoMessage.swift
//  Core
//
//  Created by Camelia Ignat on 28.10.2021.
//  Copyright © 2021 Andrei Moldovan. All rights reserved.
//

import Foundation

class InfoMessage: Message {
    let versionInfo: VersionInfoModel
    
    enum CodingKeys: String, CodingKey {
        case versionInfo = "VersionInfo"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        versionInfo = try container.decode(VersionInfoModel.self, forKey: .versionInfo)
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(versionInfo, forKey: .versionInfo)
    }
}

struct VersionInfoModel: Codable {
    let name: String
    let implementationTitle: String
    let implementationVendor: String
    let implementationVersion: String
    let specificationTitle: String
    let specificationVendor: String
    let specificationVersion: String
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case implementationTitle = "Implementation-Title"
        case implementationVendor = "Implementation-Vendor"
        case implementationVersion = "Implementation-Version"
        case specificationTitle = "Specification-Title"
        case specificationVendor = "Specification-Vendor"
        case specificationVersion = "Specification-Version"
    }
}
