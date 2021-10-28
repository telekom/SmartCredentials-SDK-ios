//
//  Messages.swift
//  EID
//
//  Created by Camelia Ignat on 14.10.2021.
//

import Foundation

enum Messages: String {
    case auth = "AUTH"
    case accessRights = "ACCESS_RIGHTS"
    case apiLevel = "API_LEVEL"
    case certificate = "CERTIFICATE"
    case changePIN = "CHANGE_PIN"
    case enterPIN = "ENTER_PIN"
    case enterNewPIN = "ENTER_NEW_PIN"
    case enterPUK = "ENTER_PUK"
    case insertCard = "INSERT_CARD"
    case reader = "READER"
    case readerList = "READER_LIST"
    case enterCAN = "ENTER_CAN"
    case info = "INFO"
    case internalError = "INTERNAL_ERROR"
    case invalid = "INVALID"
    case badState = "BAD_STATE"
    case unknown = "UNKNOWN_COMMAND"
}

class Message: Codable {
    var msg: String
    
    private enum CodingKeys : String, CodingKey {
        case msg = "msg"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        msg = try container.decode(String.self, forKey: .msg)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(msg, forKey: .msg)
    }
}
