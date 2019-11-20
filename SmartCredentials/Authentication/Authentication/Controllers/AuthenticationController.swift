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

#if canImport(Core)
import Core
#endif

class AuthenticationController {
    
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

// MARK: - Authentication API
extension AuthenticationController: AuthenticationAPI {
    
    func getAuthService(with configuration: [String : Any], authStateKey: String, completionHandler: @escaping AuthServiceCompletionHandler) {
        guard isJailbroken() == false else {
            logger?.log(.error, message: Constants.Logger.jailbreakError, className: className)
            completionHandler(.failure(error: .jailbreakDetected))
            return
        }
        
        AuthorizationModuleProvider.authorizationModule(with: configuration, authStateKey: authStateKey) { result in
            switch result {
            case .success(let authModule):
                completionHandler(.success(result: authModule))
            case .failure(let error):
                completionHandler(.failure(error: error))
            }
        }
    }
}

extension AuthenticationController: Nameable {
}
