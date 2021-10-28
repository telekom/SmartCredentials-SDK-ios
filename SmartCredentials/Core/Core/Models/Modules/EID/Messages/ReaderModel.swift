//
//  ReaderModel.swift
//  Core
//
//  Created by Camelia Ignat on 28.10.2021.
//  Copyright © 2021 Andrei Moldovan. All rights reserved.
//

import Foundation

struct ReaderModel: Codable {
    let name: String?
    let attached: Bool?
    let keypad: Bool?
    let card: CardMessage?
}
