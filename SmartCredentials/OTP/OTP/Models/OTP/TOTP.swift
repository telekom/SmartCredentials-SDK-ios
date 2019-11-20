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

class TOTP: OTP {
    
    var period: Int

    init(algorithm: HMACAlgorithm = .SHA1, numberOfDigits: Int = 6, secretKey: Data, period: Int = 30) {
        self.period = period
        
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
        
        var period = 30
        if let receivedPeriod = dictionary[OTPKeys.period] as? Int {
            period = receivedPeriod
        }
        
        guard let secretKeyString = dictionary[OTPKeys.secretKey] as? String,
            let secretKeyData = secretKeyString.lowercased().base32DecodedData else {
                return nil
        }
        
        self.init(algorithm: algorithm, numberOfDigits: numberOfDigits, secretKey: secretKeyData, period: period)
    }
    
    func otpCode() -> OTPCode {
        let now = Date()
        
        let q = Int64(now.timeIntervalSince1970) / Int64(period)
        let date = Date(timeIntervalSince1970: TimeInterval(q * Int64(period)))

        let otpCode = code(q)
        let remainingSeconds = now.timeIntervalSince(date)
        
        return OTPCode(totpCode: otpCode, remainingSeconds: period - Int(remainingSeconds))
    }
}
