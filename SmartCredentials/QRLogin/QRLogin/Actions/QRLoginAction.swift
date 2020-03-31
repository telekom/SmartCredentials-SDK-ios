/*
* Copyright (c) 2019 Telekom Deutschland AG
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import Foundation
import Core

public class QRLoginAction: IActionModule {
    
    // MARK: - Initializer
    public required init(actionId: String, moduleName: String, data: [String : Any]) {
        super.init(actionId: actionId, moduleName: moduleName, data: data)
    }
    
    // MARK: - Execute
    public override func execute(with item: ItemEnvelope, completionHandler: @escaping ExecCallCompletionHandler) {
        
        guard let websocketURLString = data[QRLoginKeys.webSocketURL] as? String,
            let webSocketURL = URL(string: websocketURLString) else {
                completionHandler(.failure(error: QRLoginActionError.invalidWebSocketURLReceived))
                return
        }
        
        let privateData = item.itemMetadata.itemPrivateData.privateData
        guard let qrCode = privateData[QRLoginKeys.qrCode] as? String else {
            completionHandler(.failure(error: QRLoginActionError.invalidQRCodeReceived))
            return
        }
        
        // TODO: inject here necessary attributes
        let qrLoginService = QRLoginService()
        qrLoginService.getRefreshTokenForQRLogin(with: webSocketURL,
                                                 certificateData: privateData[QRLoginKeys.certificateData] as? Data,
                                                 qrCode: qrCode,
                                                 idToken: privateData[QRLoginKeys.idToken] as? String,
                                                 refreshToken: privateData[QRLoginKeys.refreshToken] as? String) { result in
                                                    self.handleQRLogin(result, completionHandler: completionHandler)
        }
    }
    
    private func handleQRLogin(_ result: SmartCredentialsAPIResult<[String: Any]>, completionHandler: ExecCallCompletionHandler) {
        switch result {
        case .success(let data):
            completionHandler(.success(result: data))
        case .failure(let scError):
            switch scError {
            case .invalidJSONError:
                completionHandler(.failure(error: QRLoginActionError.invalidJSON))
            case .invalidMessageError:
                completionHandler(.failure(error: QRLoginActionError.invalidMessage))
            case .invalidQRCodeReceived:
                completionHandler(.failure(error: QRLoginActionError.invalidQRCodeReceived))
            case .invalidAccessTokenError:
                completionHandler(.failure(error: QRLoginActionError.invalidAccessToken))
            case .qrLoginFail:
                completionHandler(.failure(error: QRLoginActionError.qrLoginFailed))
            default:
                completionHandler(.failure(error: QRLoginActionError.qrLoginFailed))
            }
        @unknown default:
            // Any future cases not recognized by the compiler yet
            break
        }
    }
}

enum QRLoginActionError: Error {
    /**
     Error received in case of receiving invalid json format throught websocket (QR Code Login)
     */
    case invalidJSON
    
    /**
     Error received in case of receiving invalid message format throught websocket (QR Code Login)
     */
    case invalidMessage
    
    /**
     Error received when an invalid item envelope was used to login using QR (QR Code Login)
     */
    case invalidQRCodeReceived
    
    /**
     Error received when an invalid websocket url was used to login using QR (QR Code Login)
     */
    case invalidWebSocketURLReceived
    
    /**
     Error received when auth was successful, but received invalid access token through websocket (QR Code Login)
     */
    case invalidAccessToken
    
    /**
     Error received in case of un unsuccessful QR Login (QR Code Login)
     */
    case qrLoginFailed
}
