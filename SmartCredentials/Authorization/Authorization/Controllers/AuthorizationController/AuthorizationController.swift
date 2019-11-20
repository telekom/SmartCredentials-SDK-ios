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

import LocalAuthentication

#if canImport(Core)
import Core
#endif

class AuthorizationController {
    
    let logger = LoggerProvider.sharedInstance.logger
    var configuration: SmartCredentialsConfiguration
    
    // MARK: - Initializers
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

// MARK: - Authorization API
extension AuthorizationController: AuthorizationAPI {

    func authorize(with completionHandler: @escaping AuthorizationCompletionHandler) {
        guard isJailbroken() == false else {
            logger?.log(.error, message: Constants.Logger.jailbreakError, className: className)
            completionHandler(.failure(error: .jailbreakDetected))
            return
        }
        
        let localAuthenticationContext = LAContext()
        let reasonString = Constants.Authorization.reasonString
        let logger = LoggerProvider.sharedInstance.logger
        
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reasonString) { success, evaluateError in
                if success {
                    completionHandler(.success)
                } else {
                    guard let error = evaluateError else {
                        return
                    }
                    
                    switch error {
                    case LAError.appCancel:
                        logger?.log(.error, message: Constants.AuthorizationLogger.authAppCancel, className: self.className)
                        completionHandler(.failure(error: .authAppCancel))
                    case LAError.systemCancel:
                        logger?.log(.error, message: Constants.AuthorizationLogger.authSystemCancel, className: self.className)
                        completionHandler(.failure(error: .authSystemCancel))
                    case LAError.userCancel:
                        logger?.log(.error, message: Constants.AuthorizationLogger.authUserCancel, className: self.className)
                        completionHandler(.failure(error: .authUserCancel))
                    default:
                        logger?.log(.error, message: Constants.AuthorizationLogger.authFailed, className: self.className)
                        completionHandler(.failure(error: .authFailed))
                    }
                }
            }
        } else {
            logger?.log(.error, message: Constants.AuthorizationLogger.authFailed, className: self.className)
            completionHandler(.failure(error: .authFailed))
        }
    }
}

extension AuthorizationController: Nameable {
}
