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

#if canImport(Core)
import Core
#endif

class EncryptionController: EncryptionAPI {
    
    let logger = LoggerProvider.sharedInstance.logger
    var configuration: SmartCredentialsConfiguration
    
    public init(configuration: SmartCredentialsConfiguration) {
        self.configuration = configuration
    }
    
    func getPublicKey(for tag: String) -> SmartCredentialsAPIResult<String> {
        guard isJailbroken() == false else {
            logger?.log(.error, message: Constants.Logger.jailbreakError, className: className)
            return .failure(error: .jailbreakDetected)
        }
    
        let dataTag = tag.data(using: .utf8)!
        let privateAttributes = [String(kSecAttrIsPermanent): true,
                                 String(kSecAttrApplicationTag): dataTag] as [String : Any]
        
        let publicAttributes = [String(kSecAttrIsPermanent): true,
                                String(kSecAttrApplicationTag): dataTag,
                                String(kSecClass): kSecClassKey,
                                String(kSecReturnData): kCFBooleanTrue as Any] as [String : Any]
        
        let pairAttributes = [String(kSecAttrKeyType): kSecAttrKeyTypeRSA,
                              String(kSecAttrKeySizeInBits): Constants.CryptographicKeys.keySizeInBits,
                              String(kSecPrivateKeyAttrs): privateAttributes,
                              String(kSecPublicKeyAttrs): publicAttributes] as [String : Any]
        
        var publicRef: SecKey?
        var privateRef: SecKey?
        let generatePairOSStatus = SecKeyGeneratePair(pairAttributes as CFDictionary, &publicRef, &privateRef)
        
        switch generatePairOSStatus {
        case noErr:
            var resultPublicKey: AnyObject?
            let statusPublicKey = SecItemCopyMatching(publicAttributes as CFDictionary, &resultPublicKey)
            
            guard statusPublicKey == noErr, let publicKey = resultPublicKey else {
                return .failure(error: .generatingKeysFailed(osStatus: statusPublicKey))
            }
            
            let publicKeyString = publicKey.base64EncodedString(options: .lineLength64Characters)
            return .success(result: publicKeyString)
            
        default:
            return .failure(error: .generatingKeysFailed(osStatus: generatePairOSStatus))
        }
    }
    
    func encrypt(_ text: String, with keyTag: String) -> SmartCredentialsAPIResult<String> {
        guard isJailbroken() == false else {
            logger?.log(.error, message: Constants.Logger.jailbreakError, className: className)
            return .failure(error: SmartCredentialsAPIError.jailbreakDetected)
        }
        
        let dataTag = keyTag.data(using: .utf8)!
        let publicAttributes = [String(kSecClass): kSecClassKey,
                                String(kSecAttrApplicationTag): dataTag,
                                String(kSecAttrKeyType): kSecAttrKeyTypeRSA,
                                String(kSecReturnRef): true] as [String : Any]
        
        var resultPublicKey: AnyObject?
        let statusPublicKey = SecItemCopyMatching(publicAttributes as CFDictionary, &resultPublicKey)
        
        guard statusPublicKey == noErr, let publicKey = resultPublicKey else {
            return .failure(error: .encryptingTextFailed(osStatus: statusPublicKey))
        }
        
        let blockSize = SecKeyGetBlockSize(publicKey as! SecKey)
        var messageEncrypted = [UInt8](repeating: 0, count: blockSize)
        var messageEncryptedSize = blockSize
        
        let status = SecKeyEncrypt(publicKey as! SecKey,
                                   SecPadding.PKCS1,
                                   text,
                                   text.count,
                                   &messageEncrypted,
                                   &messageEncryptedSize)
        
        if status != noErr {
            return .failure(error: .encryptingTextFailed(osStatus: statusPublicKey))
        }
        
        return .success(result: String(cString: messageEncrypted))
    }
    
    // MARK: - Jailbreak Check
    private func isJailbroken() -> Bool {
        if configuration.jailbreakCheckEnabled {
            return JailbreakDetection.isJailbroken()
        }
        return false
    }
}

extension EncryptionController: Nameable {
}
