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

/// Interface defining the communication betweeen AuthState implementation from SmartCredentialsLibrary and 3rd party application
public protocol AuthStateProtocol: class {

    /// Used to return Refresh Token
    ///
    /// - Returns: Refresh Token
    func getRefreshToken() -> String?
    
    /// Used to return ID Token
    ///
    /// - Returns: ID Token
    func getIDToken() -> String?

    /// Used to return Access Token
    ///
    /// - Returns: Access Token
    func getAccessToken() -> String?
    
    /// Used to return the Access Token expiration date
    ///
    /// - Returns: Access Token expiration date
    func getAccessTokenExpirationDate() -> Date?
    
    /// Used to return the userInfoEndpoint
    ///
    /// - Returns: URL?
    func getUserInfoEndpoint() -> URL?
    
    /// Used to verify the authorization state
    ///
    /// - Returns: Bool
    func isAuthorized() -> Bool
    
}
