//
//  ReaderListMessage.swift
//  Core
//
//  Created by Camelia Ignat on 28.10.2021.
//  Copyright © 2021 Andrei Moldovan. All rights reserved.
//

import Foundation

public class ReaderListMessage: Message {
    public let readers: [ReaderModel]
    
    private enum CodingKeys : String, CodingKey {
        case readers
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        readers = try container.decode([ReaderModel].self, forKey: .readers)
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(readers, forKey: .readers)
    }
}
