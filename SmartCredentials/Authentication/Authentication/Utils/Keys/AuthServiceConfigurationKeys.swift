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


/// Constant used for populating the configuration in AuthService workflow
public enum AuthServiceConfigurationKeys {
    
    /// Key for specifying the issuer from which the configuration will be discovered
    public static let issuer = "issuer"
    
    /// Key for specifying the the OAuth client ID
    public static let clientID = "clientID"
    
    /// Key for specifying the OAuth redirect URI for the clientID
    public static let redirectURI = "redirectURI"
    
    /// Key for specifying the OAuth scopes for authorization requests
    public static let scopes = "scopes"
    
}
