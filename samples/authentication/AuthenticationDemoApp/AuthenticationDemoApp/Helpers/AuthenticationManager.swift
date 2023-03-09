//
//  AuthenticationManager.swift
//  AuthenticationDemoApp
//
//  Created by Camelia Ignat on 17.02.2023.
//

import Foundation
import Authentication
import Core
import UIKit
import AppAuth

class AuthenticationManager {
    static let shared = AuthenticationManager()
    
    let dictionaryGoogle = ["issuer": "https://accounts.google.com",
                      "clientID": "622449367222-7kn5qk1uh8chgkjstfk1i0flg7vcobe2.apps.googleusercontent.com",
                      "redirectURI": "com.googleusercontent.apps.622449367222-7kn5qk1uh8chgkjstfk1i0flg7vcobe2:/oauth2redirect/google",
                      "scopes": [OIDScopeKeys.openid, OIDScopeKeys.profile, OIDScopeKeys.email]] as [String : Any]
    var googleAuthService: AuthServiceProtocol?
    
    private let authentication = SmartCredentialsAuthenticationFactory.smartCredentialsAuthenticationAPI(configuration: SCConfiguration.sharedInstance.current)
    private let authStateKey = "authStateKeyGoogle"
    
    func doLogin(with viewController: UIViewController, completionHandler: @escaping Authentication.AuthServiceSettingsCompletionHandler) {

        if let isAuthorized = AuthenticationManager.shared.googleAuthService?.isAuthorized(), isAuthorized {
            performLogin(with: viewController, completionHandler: completionHandler)
            return
        }

        authentication.getAuthService(with: AuthenticationManager.shared.dictionaryGoogle, authStateKey: authStateKey) { result in
            switch result {
            case .success(let result):
                guard let authService = result as? AuthServiceProtocol else {
                    return
                }

                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    return
                }

                AuthenticationManager.shared.googleAuthService = authService
                appDelegate.currentAuthService = authService
                self.performLogin(with: viewController, completionHandler: completionHandler)
            case .failure(let error):
                completionHandler(.failure(error: error))
            @unknown default:
                fatalError()
            }
        }
    }
    
    func isLoggedIn(completionHandler: @escaping (Bool) -> ()) {
        authentication.getAuthService(with: dictionaryGoogle, authStateKey: authStateKey) { result in
            switch result {
            case .success(result: let result):
                if (((result as? AuthServiceProtocol)?.authState.isAuthorized()) == true) {
                    self.googleAuthService = result as? any AuthServiceProtocol
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            case .failure(error: _):
                completionHandler(false)
            }
        }
    }
    
    private func performLogin(with viewController: UIViewController, completionHandler: @escaping Authentication.AuthServiceSettingsCompletionHandler) {
        AuthenticationManager.shared.googleAuthService?.doLogin(with: viewController, completionHandler: { (result) in
                        
            switch result {
            case .success:
                completionHandler(.success)
            case .failure(error: let error):
                completionHandler(.failure(error: error))
            }
        })
    }
}

class SCConfiguration {
    static let sharedInstance = SCConfiguration()
    let current = SmartCredentialsConfiguration(userId: "user")
}
