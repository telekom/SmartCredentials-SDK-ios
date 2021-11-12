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

import AppAuth
import Core

typealias PostRegistrationCallback = (_ configuration: OIDServiceConfiguration?, _ registrationResponse: OIDRegistrationResponse?, _ error: SmartCredentialsAPIError?) -> ()

class DefaultAuthService: NSObject, AuthServiceProtocol {
    
    var issuer: String
    var clientID: String?
    var redirectURI: String
    var authStateKey: String
    var scopes: [String]
    var authState: AuthStateProtocol
    
    private var defaultAuthState: DefaultAuthState? {
        return authState as? DefaultAuthState
    }
    
    private var authConfiguration: OIDServiceConfiguration?
    private var currentAuthorizationFlow: OIDExternalUserAgentSession?
    private var presentingViewController: UIViewController?
    
    init(issuer: String, clientID: String?, redirectURI: String, scopes: [String], authStateKey: String) {
        self.issuer = issuer
        self.clientID = clientID
        self.redirectURI = redirectURI
        self.authStateKey = authStateKey
        self.scopes = scopes
        self.authState = DefaultAuthState(authStateKey: self.authStateKey)
    }
    
    /// Discovers endpoint
    func discoverConfiguration(completionHandler: @escaping AuthServiceSettingsCompletionHandler) {
        guard let issuer = URL(string: issuer) else {
            completionHandler(.failure(error: .invalidIssuer))
            return
        }
        
        OIDAuthorizationService.discoverConfiguration(forIssuer: issuer) { configuration, error in
            guard let config = configuration else {
                self.defaultAuthState?.setAuthState(nil)
                completionHandler(.failure(error: .retrievingConfiguration))
                
                return
            }
            
            self.authConfiguration = config
            self.defaultAuthState?.loadState()
            completionHandler(.success)
        }
    }
}

//MARK: AuthService Methods
extension DefaultAuthService {
    func canResumeExternalUserAgentFlow(with URL: URL) -> Bool {
        if let authFlow = currentAuthorizationFlow, authFlow.resumeExternalUserAgentFlow(with: URL) {
            self.currentAuthorizationFlow = nil
            return true
        }
        
        return false
    }
    
    public func doLogin(with presentingViewController: UIViewController, completionHandler: @escaping AuthServiceSettingsCompletionHandler) {
        
        guard let config = authConfiguration else {
            defaultAuthState?.setAuthState(nil)
            completionHandler(.failure(error: .retrievingConfiguration))
            
            return
        }
        
        self.presentingViewController = presentingViewController
        
        if let clientId = self.clientID {
            doAuthWithAutoCodeExchange(configuration: config, clientID: clientId, clientSecret: nil, completionHandler: { result in
                switch result {
                case .success:
                    completionHandler(.success)
                case .failure(_):
                    completionHandler(.failure(error: .authorizationError))
                @unknown default:
                    // Any future cases not recognized by the compiler yet
                    break
                }
            })
        } else {
            self.doClientRegistration(configuration: config) { configuration, response, error in
                
                if let registrationError = error {
                    completionHandler(.failure(error: registrationError))
                    return
                }
                
                guard let configuration = configuration else {
                    completionHandler(.failure(error: .retrievingConfiguration))

                    return
                }
                
                guard let registrationResponse = response else {
                    completionHandler(.failure(error: .invalidRegistrationResponse))
                    return
                }
                
                self.doAuthWithAutoCodeExchange(configuration: configuration, clientID: registrationResponse.clientID, clientSecret: response?.clientSecret, completionHandler: { result in
                    switch result {
                    case .success:
                        completionHandler(.success)
                    case .failure(_):
                        completionHandler(.failure(error: .authorizationError))
                    @unknown default:
                        // Any future cases not recognized by the compiler yet
                        break
                    }
                })
            }
        }
    }
    
    public func doLogout() {
        defaultAuthState?.setAuthState(nil)
    }
    
    //MARK: - Registration
    func doClientRegistration(configuration: OIDServiceConfiguration, callback: @escaping PostRegistrationCallback) {
        
        guard let kRedirectURI = URL(string: redirectURI) else {
            callback(nil, nil, .invalidAuthServiceURL)
            return
        }
        
        let request: OIDRegistrationRequest = OIDRegistrationRequest(configuration: configuration,
                                                                     redirectURIs: [kRedirectURI],
                                                                     responseTypes: nil,
                                                                     grantTypes: nil,
                                                                     subjectType: nil,
                                                                     tokenEndpointAuthMethod: Constants.AuthService.clientSecretPost,
                                                                     additionalParameters: nil)
        
        // Performs registration request
        OIDAuthorizationService.perform(request) { response, error in
            
            if let regResponse = response {
                
                if let authState = self.authState as? DefaultAuthState {
                    authState.setAuthState(OIDAuthState(registrationResponse: regResponse))
                }
                
                callback(configuration, regResponse, nil)
            } else {
                self.defaultAuthState?.setAuthState(nil)
                callback(nil, nil, .authRegistrationFailed)
            }
        }
    }

    //MARK: - AuthWithAutoCodeExchange
    func doAuthWithAutoCodeExchange(configuration: OIDServiceConfiguration, clientID: String, clientSecret: String?, completionHandler: @escaping AuthServiceSettingsCompletionHandler) {
        
        guard let kRedirectURI = URL(string: redirectURI) else {
            completionHandler(.failure(error: .invalidRedirectURI))
            return
        }
        
        guard let viewController = presentingViewController else {
            return
        }
        
        let request = OIDAuthorizationRequest(configuration: configuration,
                                              clientId: clientID,
                                              clientSecret: clientSecret,
                                              scopes: scopes,
                                              redirectURL: kRedirectURI,
                                              responseType: OIDResponseTypeCode,
                                              additionalParameters: nil)
        
        currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request, presenting: viewController) { authState, error in
            
            if let authState = authState {
                self.defaultAuthState?.setAuthState(authState)
                completionHandler(.success)
            } else {
                self.defaultAuthState?.setAuthState(nil)
                completionHandler(.failure(error: .authorizationError))
            }
        }
    }
}

extension DefaultAuthService {
    
    func performAction(completionHandler: @escaping AuthServicePerformActionCompletionHandler) {
        defaultAuthState?.performAction(completionHandler: completionHandler)
    }
    
    func refreshAccessToken(completionHandler: @escaping AuthServicePerformActionCompletionHandler) {
        defaultAuthState?.refreshAccessToken(completionHandler: completionHandler)
    }
    
    func isAuthorized() -> Bool {
        guard let authState = defaultAuthState else {
            return false
        }
        
        return authState.isAuthorized()
    }
}
