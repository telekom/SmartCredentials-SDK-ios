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

class DefaultAuthState: NSObject, AuthStateProtocol {
    
    var authState: OIDAuthState?
    var authStateKey: String
    
    init(authStateKey: String) {
        self.authStateKey = authStateKey
    }
    
    func getRefreshToken() -> String? {
        return authState?.refreshToken
    }
    
    func getIDToken() -> String? {
        return authState?.lastTokenResponse?.idToken
    }
    
    func getAccessToken() -> String? {
        return authState?.lastTokenResponse?.accessToken
    }
    
    func getAccessTokenExpirationDate() -> Date? {
        return authState?.lastTokenResponse?.accessTokenExpirationDate
    }
    
    func getUserInfoEndpoint() -> URL? {
        return authState?.lastAuthorizationResponse.request.configuration.discoveryDocument?.userinfoEndpoint
    }
    
    func isAuthorized() -> Bool {
        guard let authState = authState else {
            return false
        }
        
        return authState.isAuthorized
    }
   
    func performAction(completionHandler: @escaping AuthServicePerformActionCompletionHandler) {
        authState?.performAction(freshTokens: { (accessToken, idToken, error) in
            completionHandler(accessToken, idToken, error)
        })
    }
    
    func refreshAccessToken(completionHandler: @escaping AuthServicePerformActionCompletionHandler) {
        authState?.setNeedsTokenRefresh()
        performAction { (accessToken, idToken, error) in
            completionHandler(accessToken, idToken, error)
        }
    }
    
}

//MARK: OIDAuthState Delegate
extension DefaultAuthState: OIDAuthStateChangeDelegate, OIDAuthStateErrorDelegate {
    
    func didChange(_ state: OIDAuthState) {
        self.stateChanged()
    }
    
    func authState(_ state: OIDAuthState, didEncounterAuthorizationError error: Error) {
    }
    
}

// MARK: OIDAuthState set/save/load
extension DefaultAuthState {
 
    func saveState() {
        
        var data: Data? = nil
        
        if let authState = self.authState {
            data = NSKeyedArchiver.archivedData(withRootObject: authState)
        }
        
        UserDefaults.standard.set(data, forKey: authStateKey)
        UserDefaults.standard.synchronize()
    }
    
    func loadState() {
        
        guard let data = UserDefaults.standard.object(forKey: authStateKey) as? Data else {
            return
        }
        
        if let authState = NSKeyedUnarchiver.unarchiveObject(with: data) as? OIDAuthState {
            self.setAuthState(authState)
        }
    }
    
    func setAuthState(_ authState: OIDAuthState?) {
        
        if (self.authState == authState) {
            return;
        }
        self.authState = authState
        self.authState?.stateChangeDelegate = self
        self.stateChanged()
    }
    
    func stateChanged() {
        
        self.saveState()
    }
    
}
