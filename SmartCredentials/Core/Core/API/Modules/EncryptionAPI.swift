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

public protocol EncryptionAPI {
    
    /// Creates a Cryptographic keys (public key and private key) and save them in the Keychain
    /// For keypair generation RSA algorithm is used on 2048 bits
    ///
    /// - Parameter tag: public key tag
    /// - Returns: Generic enum; success -  public key string value; failure - SmartCredentialsAPIError (enum)
    func getPublicKey(for tag: String) -> SmartCredentialsAPIResult<String>
    
    /// Encrypts a text using the public key based on a specific tag
    ///
    /// - Parameters:
    ///   - text: text to encrypt
    ///   - keyTag: public key tag
    /// - Returns: Generic enum; success -  encrypted text; failure - SmartCredentialsAPIError (enum)
    func encrypt(_ text: String, with keyTag: String) -> SmartCredentialsAPIResult<String>
}
