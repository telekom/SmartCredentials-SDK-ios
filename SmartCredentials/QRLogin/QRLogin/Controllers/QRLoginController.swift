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
import Authorization

class QRLoginController {
    
    let logger = LoggerProvider.sharedInstance.logger
    var configuration: SmartCredentialsConfiguration
    var authorization: AuthorizationAPI
    var service: QRLoginService?
    
    // MARK: - Initializers
    init(configuration: SmartCredentialsConfiguration, authorization: AuthorizationAPI) {
        self.configuration = configuration
        self.authorization = authorization
    }
    
    // MARK: - Jailbreak Check
    private func isJailbroken() -> Bool {
        if configuration.jailbreakCheckEnabled {
            return JailbreakDetection.isJailbroken()
        }
        return false
    }
}

// MARK: - QR Login API
extension QRLoginController: QRLoginAPI {
    
    func authorizeUserLogin(with item: ItemEnvelope, completionHandler: @escaping UserLoginAuthorizationCompletionHandler) {
        guard isJailbroken() == false else {
            logger?.log(.error, message: Constants.Logger.jailbreakError, className: className)
            completionHandler(.failure(error: .jailbreakDetected))
            return
        }
        
        authorization.authorize { authorizationResult in
            switch authorizationResult {
            case .success:
                self.getRefreshToken(for: item, completionHandler: { getRefreshTokenResult in
                    switch getRefreshTokenResult {
                    case .success(let privateDataDictionary):
                        var responseItem = item
                        let privateData = ItemPrivateData(privateData: privateDataDictionary)
                        responseItem.itemMetadata.itemPrivateData = privateData
                        completionHandler(.success(result: responseItem))
                    case .failure(let error):
                        completionHandler(.failure(error: error))
                    }
                })
            case .failure(let error):
                completionHandler(.failure(error: error))
            }
        }
    }
    
    private func getRefreshToken(for item: ItemEnvelope, completionHandler: @escaping GetRefreshTokenCompletionHandler) {
        
        guard let websocketURLString = item.identifier[QRLoginKeys.webSocketURL] as? String,
            let webSocketURL = URL(string: websocketURLString) else {
                completionHandler(.failure(error: .invalidWebSocketURLReceived))
                return
        }
        
        guard let qrCode = item.identifier[QRLoginKeys.qrCode] as? String else {
            completionHandler(.failure(error: .invalidQRCodeReceived))
            return
        }
        
        service = QRLoginService()
        service?.getRefreshTokenForQRLogin(with: webSocketURL,
                                          certificateData: item.identifier[QRLoginKeys.certificateData] as? Data,
                                          qrCode: qrCode,
                                          idToken: item.identifier[QRLoginKeys.idToken] as? String,
                                          refreshToken: item.identifier[QRLoginKeys.refreshToken] as? String,
                                          completionHandler: completionHandler)
    }
}

extension QRLoginController: Nameable {
}
