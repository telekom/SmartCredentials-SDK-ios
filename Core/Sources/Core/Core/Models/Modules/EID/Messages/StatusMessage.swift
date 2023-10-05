//
//  StatusMessage.swift
//  Core
//
//  Created by Camelia Ignat on 01.09.2022.
//  Copyright © 2022 Andrei Moldovan. All rights reserved.
//

import Foundation

public class StatusMessage: Message {
    public let workflow: String?
    public let progress: Int?
    public let state: String?
    
    private enum CodingKeys : String, CodingKey {
        case workflow
        case progress
        case state
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        workflow = try container.decodeIfPresent(String.self, forKey: .workflow)
        progress = try container.decodeIfPresent(Int.self, forKey: .progress)
        state = try container.decodeIfPresent(String.self, forKey: .state)
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(workflow, forKey: .workflow)
        try container.encode(progress, forKey: .progress)
        try container.encode(state, forKey: .state)
    }
}
