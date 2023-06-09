//
//  SetCardCommand.swift
//  Core
//
//  Created by Camelia Ignat on 02.09.2022.
//  Copyright © 2022 Andrei Moldovan. All rights reserved.
//

import Foundation

public class SetCardCommand: Command {
    public var name: String
    public var simulator: SimulatorModel?
    
    private enum CodingKeys : String, CodingKey {
        case name
        case simulator
    }
    
    public init(cmd: String, name: String, simulator: SimulatorModel?) {
        self.name = name
        self.simulator = simulator
        super.init(cmd: cmd)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        simulator = try container.decodeIfPresent(SimulatorModel.self, forKey: .simulator)
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(simulator, forKey: .simulator)
    }
}

public struct SimulatorModel: Codable {
    public let files: [FileModel?]
    public let keys: [KeysModel?]
    
    public init(files: [FileModel?], keys: [KeysModel?]) {
        self.files = files
        self.keys = keys
    }
}

public struct FileModel: Codable {
    public let fileId: String
    public let shortFileId: String
    public let content: String
    
    public init(fileId: String, shortFileId: String, content: String) {
        self.fileId = fileId
        self.shortFileId = shortFileId
        self.content = content
    }
}

public struct KeysModel: Codable {
    public let id: String
    public let privateKey: String
    
    public init(id: String, privateKey: String) {
        self.id = id
        self.privateKey = privateKey
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case privateKey = "private"
    }
}
