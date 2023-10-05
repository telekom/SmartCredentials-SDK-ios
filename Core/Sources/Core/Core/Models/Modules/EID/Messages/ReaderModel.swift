//
//  ReaderModel.swift
//  Core
//
//  Created by Camelia Ignat on 28.10.2021.
//  Copyright © 2021 Andrei Moldovan. All rights reserved.
//

import Foundation

public struct ReaderModel: Codable {
    public let name: String?
    public let attached: Bool?
    public let keypad: Bool?
    public let card: CardMessage?
}
