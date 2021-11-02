//
//  InfoMessage.swift
//  Core
//
//  Created by Camelia Ignat on 28.10.2021.
//  Copyright © 2021 Andrei Moldovan. All rights reserved.
//

import Foundation

public class InfoMessage: Message {
    public let versionInfo: VersionInfoModel
    
    enum CodingKeys: String, CodingKey {
        case versionInfo = "VersionInfo"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        versionInfo = try container.decode(VersionInfoModel.self, forKey: .versionInfo)
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(versionInfo, forKey: .versionInfo)
    }
}

public struct VersionInfoModel: Codable {
    public let name: String
    public let implementationTitle: String
    public let implementationVendor: String
    public let implementationVersion: String
    public let specificationTitle: String
    public let specificationVendor: String
    public let specificationVersion: String
    
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
