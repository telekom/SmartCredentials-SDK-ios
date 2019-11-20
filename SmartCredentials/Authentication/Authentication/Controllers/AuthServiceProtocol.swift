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

/// Completion handler which receives two optional strings as parameters and an optional error in case of a failure
/// First string representing the access token
/// Second string representing the id token
public typealias AuthServicePerformActionCompletionHandler = (String?, String?, Error?) -> ()

public typealias AuthServiceSettingsCompletionHandler = (SmartCredentialsAPIEmptyResult) -> ()

/// Interface defining the communication betweeen AuthService implementation from SmartCredentialsLibrary and 3rd party application
public protocol AuthServiceProtocol: class {
    
    /// Issuer from which the configuration will be discovered
    var issuer: String { get set }
    
    /// Client ID from which the configuration will be discovered
    var clientID: String? { get set }
    
    /// RedirectURI from which the configuration will be discovered
    var redirectURI: String { get set }
    
    /// Protocol for managing token exchange
    var authState: AuthStateProtocol {get set}
    
    /// Key used to store the authState
    var authStateKey: String { get set }
    
    /// Scopes used for authorizatiuon requests
    var scopes: [String] { get set }
    
    /// Used for performing login action using specified configuration
    ///
    /// - Parameters:
    ///   - presentingViewController: View Controller which will present the login screen
    ///   - completionHandler: Enum; success - void; failure - SmartCredentialsAPIError (enum)
    /// - Returns: void
    func doLogin(with presentingViewController: UIViewController, completionHandler: @escaping AuthServiceSettingsCompletionHandler)
    
    /// Used for performing logout
    ///
    /// - Returns: void
    func doLogout()
    
    /// Used for checking if the Authorization flow can be resumed using the URL received
    /// Should be called in aplication(_ app:, url:, options)
    ///
    /// - Parameter URL: The redirect URL invoked by the server.
    /// - Returns: Bool
    func canResumeExternalUserAgentFlow(with URL: URL) -> Bool

    /// Used to refresh Access Token and ID Token if Access Token expired
    ///
    /// - Parameter completionHandler: completion handler with Access Token, ID Token and Error as parameter
    /// - Returns: void
    func performAction(completionHandler: @escaping AuthServicePerformActionCompletionHandler)

    /// Used to refresh Access Token even if the Access Token is still valid
    ///
    /// - Parameter completionHandler: completion handler with Access Token, ID Token and Error as parameter
    /// - Returns: void
    func refreshAccessToken(completionHandler: @escaping AuthServicePerformActionCompletionHandler)
    
    
    /// Used to verify the authorization state
    ///
    /// - Returns: Bool
    func isAuthorized() -> Bool
    
}
