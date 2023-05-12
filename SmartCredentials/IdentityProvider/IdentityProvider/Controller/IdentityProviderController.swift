//
//  IdentityProviderController.swift
//  IdentityProvider
//
//  Created by Camelia Ignat on 02.05.2023.
//

import Foundation
import Core

class IdentityProviderController {
    var configuration: SmartCredentialsConfiguration
    let requests = Requests()
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

extension IdentityProviderController: IdentityProviderAPI {
    func getOperatorToken(baseURL: String, credentials: String, clientId: String, scope: String, completionHandler: @escaping Core.IdentityProviderCompletionHandler) {
        if !isJailbroken() {
            requests.getAccessTokenRequest(url: baseURL, credentials: credentials) {result in
                switch result {
                case .success(let accessToken):
                    break
                case .failure(let error):
                    break
                }
            }
        }
    }
    
    func getOperatorToken(appToken: String, clientId: String, scope: String, completionHandler: @escaping Core.IdentityProviderCompletionHandler) {
        if !isJailbroken() {
            requests.getBearerTokenRequest(accessToken: appToken, clientId: clientId, scope: scope)
        }
    }
}
