//
//  EIDController.swift
//  EID
//
//  Created by Camelia Ignat on 18.10.2021.
//

import Foundation
import Core
import AusweisApp2
import UIKit

class EIDController {
    var configuration: SmartCredentialsConfiguration
    
    typealias MessageCompletionHandler = (Message?, Error?) -> ()
    typealias AuthCompletionHandler = (AuthMessage?) -> ()
    static var completionHandler: MessageCompletionHandler!
    
    init(configuration: SmartCredentialsConfiguration) {
        self.configuration = configuration
    }
    
    // MARK: - Jailbreak Check
    private func isJailbroken() -> Bool {
        if configuration.jailbreakCheckEnabled {
            return JailbreakDetection.isJailbroken()
        }
        return false
    }
}

extension EIDController: EIDAPI {
    func initialize(completionHandler: @escaping (Message?, Error?) -> ()) {
        EIDController.completionHandler = completionHandler
        ausweisapp2_init( { response in
            guard let response = response else {
                // communication initiated
                EIDController.completionHandler(nil, nil)
                return
            }
            
            let responseString = String(cString: response)
            guard let data = responseString.data(using: String.Encoding.utf8) else { return }
            do {
                let message = try JSONDecoder().decode(Message.self, from: data)
                guard let messageType = Messages(rawValue: message.msg) else { return }
                switch messageType {
                case .auth:
                    let authMessage = try JSONDecoder().decode(AuthMessage.self, from: data)
                    EIDController.completionHandler(authMessage, nil)
                case .accessRights:
                    let accessRightsMessage = try JSONDecoder().decode(AccessRightsMessage.self, from: data)
                    EIDController.completionHandler(accessRightsMessage, nil)
                case .apiLevel:
                    let apiLevelMessage = try JSONDecoder().decode(APILevelMessage.self, from: data)
                    EIDController.completionHandler(apiLevelMessage, nil)
                case .certificate:
                    let certificateMessage = try JSONDecoder().decode(CertificateMessage.self, from: data)
                    EIDController.completionHandler(certificateMessage, nil)
                case .changePIN:
                    let changePINMessage = try JSONDecoder().decode(ChangePINMessage.self, from: data)
                    EIDController.completionHandler(changePINMessage, nil)
                case .enterPIN:
                    let enterPINMessage = try JSONDecoder().decode(EnterPINMessage.self, from: data)
                    EIDController.completionHandler(enterPINMessage, nil)
                case .enterNewPIN:
                    let enterNewPINMessage = try JSONDecoder().decode(EnterNewPINMessage.self, from: data)
                    EIDController.completionHandler(enterNewPINMessage, nil)
                case .enterPUK:
                    let enterPUKMessage = try JSONDecoder().decode(EnterPUKMessage.self, from: data)
                    EIDController.completionHandler(enterPUKMessage, nil)
                case .insertCard:
                    let insertCardMessage = try JSONDecoder().decode(InsertCardMessage.self, from: data)
                    EIDController.completionHandler(insertCardMessage, nil)
                case .reader:
                    let readerMessage = try JSONDecoder().decode(ReaderMessage.self, from: data)
                    EIDController.completionHandler(readerMessage, nil)
                case .readerList:
                    let readerListMessage = try JSONDecoder().decode(ReaderListMessage.self, from: data)
                    EIDController.completionHandler(readerListMessage, nil)
                case .enterCAN:
                    let enterCANMessage = try JSONDecoder().decode(EnterCANMessage.self, from: data)
                    EIDController.completionHandler(enterCANMessage, nil)
                case .info:
                    let infoMessage = try JSONDecoder().decode(InfoMessage.self, from: data)
                    EIDController.completionHandler(infoMessage, nil)
                case .internalError:
                    let internalErrorMessage = try JSONDecoder().decode(InternalErrorMessage.self, from: data)
                    EIDController.completionHandler(internalErrorMessage, nil)
                case .invalid:
                    let invalidMessage = try JSONDecoder().decode(InvalidMessage.self, from: data)
                    EIDController.completionHandler(invalidMessage, nil)
                case .status:
                    let statusMessage = try JSONDecoder().decode(StatusMessage.self, from: data)
                    EIDController.completionHandler(statusMessage, nil)
                case .badState:
                    let badStateMessage = try JSONDecoder().decode(BadStateMessage.self, from: data)
                    EIDController.completionHandler(badStateMessage, nil)
                case .unknownCommand:
                    let unknownCommandMessage = try JSONDecoder().decode(UnknownCommandMessage.self, from: data)
                    EIDController.completionHandler(unknownCommandMessage, nil)
                @unknown default:
                    EIDController.completionHandler(nil, SmartError.unknownMessage)
                }
            } catch {
                EIDController.completionHandler(nil, error)
            }
        }, nil)
    }
    
    func shutdown() {
        ausweisapp2_shutdown()
    }
    
    func isRunning() -> Bool {
        return ausweisapp2_is_running()
    }
    
    func sendCommand(_ command: Command, completionHandler: @escaping (Error?) -> ()) {
        do {
            if isRunning() {
                let data = try JSONEncoder().encode(command)
                if let json = String(data: data, encoding: .utf8) {
                    ausweisapp2_send(json)
                    completionHandler(nil)
                }
            } else {
                completionHandler(SmartError.lostConnection)
            }
        } catch {
            completionHandler(error)
        }
    }
    
    func setMessageReceiverCallback(completionHandler: @escaping (Message?, Error?) -> ()) {
        EIDController.completionHandler = completionHandler
    }
}

enum SmartError: Error {
    case lostConnection
    case unknownMessage
}

extension SmartError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .lostConnection:
            return "Service connection was lost."
        case .unknownMessage:
            return "Unknown message received."
        }
    }
}
