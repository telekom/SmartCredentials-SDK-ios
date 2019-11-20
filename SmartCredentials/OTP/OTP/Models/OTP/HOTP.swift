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

class HOTP: OTP {
    
    var counter: Int
    
    init(algorithm: HMACAlgorithm = .SHA1, numberOfDigits: Int = 6, secretKey: Data, counter: Int) {
        self.counter = counter
        
        super.init(algorithm: algorithm, numberOfDigits: numberOfDigits, secretKey: secretKey)
    }
    
    convenience init?(dictionary: [String: Any]) {
        var algorithm: HMACAlgorithm = .SHA1
        if let receivedAlgorithmString = dictionary[OTPKeys.hmacAlgorithm] as? String,
            let receivedAlgorithm = HMACAlgorithm(rawValue: receivedAlgorithmString) {
            algorithm = receivedAlgorithm
        }
        
        var numberOfDigits = 6
        if let receivedNumberOfDigits = dictionary[OTPKeys.numberOfDigits] as? Int {
            numberOfDigits = receivedNumberOfDigits
        }
        
        guard let secretKeyString = dictionary[OTPKeys.secretKey] as? String,
            let secretKeyData = secretKeyString.lowercased().base32DecodedData else {
                return nil
        }
        
        guard let counter = dictionary[OTPKeys.counter] as? Int else {
            return nil
        }
        
        self.init(algorithm: algorithm, numberOfDigits: numberOfDigits, secretKey: secretKeyData, counter: counter)
    }
    
    func otpCode() -> OTPCode {
        let otpCode = code(Int64(counter))
        counter += 1
        
        return OTPCode(hotpCode: otpCode, counter: counter)
    }
}
