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
    
    typealias MessageCompletionHandler = (Message?) -> ()
    static var completionHandler: MessageCompletionHandler = (nil) -> ()
    
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
    func initialize(completionHandler: @escaping (Message?) -> ()) {
        EIDController.completionHandler = completionHandler
        ausweisapp2_init { response in
            guard let response = response else {
                // communication initiated
                EIDController.completionHandler(nil)
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
                    EIDController.completionHandler(authMessage)
                case .accessRights:
                    let accessRightsMessage = try JSONDecoder().decode(AccessRightsMessage.self, from: data)
                    EIDController.completionHandler(accessRightsMessage)
                case .apiLevel:
                    let apiLevelMessage = try JSONDecoder().decode(APILevelMessage.self, from: data)
                    EIDController.completionHandler(apiLevelMessage)
                case .certificate:
                    let certificateMessage = try JSONDecoder().decode(CertificateMessage.self, from: data)
                    EIDController.completionHandler(certificateMessage)
                case .changePIN:
                    let changePINMessage = try JSONDecoder().decode(ChangePINMessage.self, from: data)
                    EIDController.completionHandler(changePINMessage)
                case .enterPIN:
                    let enterPINMessage = try JSONDecoder().decode(EnterPINMessage.self, from: data)
                    EIDController.completionHandler(enterPINMessage)
                case .enterNewPIN:
                    let enterNewPINMessage = try JSONDecoder().decode(EnterNewPINMessage.self, from: data)
                    EIDController.completionHandler(enterNewPINMessage)
                case .enterPUK:
                    let enterPUKMessage = try JSONDecoder().decode(EnterPUKMessage.self, from: data)
                    EIDController.completionHandler(enterPUKMessage)
                case .insertCard:
                    let insertCardMessage = try JSONDecoder().decode(InsertCardMessage.self, from: data)
                    EIDController.completionHandler(insertCardMessage)
                case .reader:
                    let readerMessage = try JSONDecoder().decode(ReaderMessage.self, from: data)
                    EIDController.completionHandler(readerMessage)
                case .readerList:
                    let readerListMessage = try JSONDecoder().decode(ReaderListMessage.self, from: data)
                    EIDController.completionHandler(readerListMessage)
                case .enterCAN:
                    let enterCANMessage = try JSONDecoder().decode(EnterCANMessage.self, from: data)
                    EIDController.completionHandler(enterCANMessage)
                case .info:
                    let infoMessage = try JSONDecoder().decode(InfoMessage.self, from: data)
                    EIDController.completionHandler(infoMessage)
                case .internalError:
                    let internalErrorMessage = try JSONDecoder().decode(InternalErrorMessage.self, from: data)
                    EIDController.completionHandler(internalErrorMessage)
                case .invalid:
                    let invalidMessage = try JSONDecoder().decode(InvalidMessage.self, from: data)
                    EIDController.completionHandler(invalidMessage)
                case .badState:
                    let badStateMessage = try JSONDecoder().decode(BadStateMessage.self, from: data)
                    EIDController.completionHandler(badStateMessage)
                case .unknownCommand:
                    let unknownCommandMessage = try JSONDecoder().decode(UnknownCommandMessage.self, from: data)
                    EIDController.completionHandler(unknownCommandMessage)
                @unknown default:
                    print("Error")
                }
            } catch {
                // Completion with error message
            }
        }
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
                }
            } else {
                completionHandler(SmartError.lostConnection)
            }
        } catch {
            completionHandler(error)
        }
    }
    
    func setMessageReceiverCallback() {
        
    }
}

enum SmartError: Error {
    case lostConnection
}

extension SmartError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .lostConnection:
            return "Service connection was lost."
        }
    }
}
