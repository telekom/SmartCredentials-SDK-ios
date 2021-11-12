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

import Core

struct AuthorizationModuleProvider {
    
    static func authorizationModule(with configuration: [String: Any], authStateKey: String, completionHandler: @escaping (SmartCredentialsAPIResult<AuthServiceProtocol>) -> ()) {
        
        var clientID: String? = nil
        
        guard let issuer = configuration[AuthServiceConfigurationKeys.issuer] as? String else {
            completionHandler(.failure(error: .invalidIssuer))
            return
        }
        
        if let clientIDFromDictionary = configuration[AuthServiceConfigurationKeys.clientID] as? String {
            clientID = clientIDFromDictionary
        }
        
        guard let redirectURI = configuration[AuthServiceConfigurationKeys.redirectURI] as? String else {
            completionHandler(.failure(error: .invalidRedirectURI))
            return
        }
        
        guard let scopes = configuration[AuthServiceConfigurationKeys.scopes] as? [String] else {
            completionHandler(.failure(error: .invalidScope))
            return
        }
        
        let authServiceModule = DefaultAuthService(issuer: issuer, clientID: clientID, redirectURI: redirectURI, scopes: scopes, authStateKey: authStateKey)
        authServiceModule.discoverConfiguration {result in
            switch result {
            case .success:
                completionHandler(.success(result: authServiceModule))
            case .failure(let error):
                completionHandler(.failure(error: error))
            @unknown default:
                // Any future cases not recognized by the compiler yet
                break
            }
        }
    }
}
