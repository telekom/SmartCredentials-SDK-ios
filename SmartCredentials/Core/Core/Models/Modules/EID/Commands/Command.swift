//
//  Command.swift
//  Core
//
//  Created by Camelia Ignat on 28.10.2021.
//  Copyright © 2021 Andrei Moldovan. All rights reserved.
//

import Foundation

public enum Commands: String {
    case getInfo = "GET_INFO"
    case getAPILevel = "GET_API_LEVEL"
    case setAPILevel = "SET_API_LEVEL"
    case getReader = "GET_READER"
    case getReaderList = "GET_READER_LIST"
    case runAuth = "RUN_AUTH"
    case runChangePIN = "RUN_CHANGE_PIN"
    case getAccessRights = "GET_ACCESS_RIGHTS"
    case setAccessRights = "SET_ACCESS_RIGHTS"
    case getCertificate = "GET_CERTIFICATE"
    case accept = "ACCEPT"
    case cancel = "CANCEL"
    case setPIN = "SET_PIN"
    case setNewPIN = "SET_NEW_PIN"
    case setCAN = "SET_CAN"
    case setPUK = "SET_PUK"
    case interrupt = "INTERRUPT"
}

public class Command: Codable {
    var cmd: String
    
    private enum CodingKeys : String, CodingKey {
        case cmd = "cmd"
    }
    
    public init(cmd: String) {
        self.cmd = cmd
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cmd = try container.decode(String.self, forKey: .cmd)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cmd, forKey: .cmd)
    }
}
