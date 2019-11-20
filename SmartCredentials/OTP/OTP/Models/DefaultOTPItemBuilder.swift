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

enum OTPBuilderResult {
    /**
     Success value received in case of a successful otp item creation from qr code result
     */
    case success(item: ItemEnvelope, importOTPResult: ImportOTPResult)
    
    /**
     Failure value (with SmartCredentialsAPIError value associated) received in case of an unsuccessful api call
     */
    case failure(error: SmartCredentialsAPIError)
}

class DefaultOTPItemBuilder {
    func otpItem(from qrCodeResult: (SmartCredentialsAPIResult<String>), itemId: String) -> OTPBuilderResult {
        switch qrCodeResult {
        case .success(let qrCode):
            guard let urlComponents = URLComponents(string: qrCode),
                let otp = OTPFactory.otp(from: urlComponents) else {
                    return .failure(error: .invalidQRForOTP)
            }
            
            let item: ItemEnvelope
            let result: ImportOTPResult
            if let otp = otp as? TOTP {
                result = ImportOTPResult(itemId: itemId, otpType: .TOTP)
                item = ItemEnvelopeFactory.itemEnvelope(with: itemId,
                                                        type: .totp,
                                                        identifier: [OTPKeys.secretKey: otp.secretKey.base32EncodedString,
                                                                     OTPKeys.hmacAlgorithm: otp.algorithm.rawValue,
                                                                     OTPKeys.numberOfDigits: otp.numberOfDigits,
                                                                     OTPKeys.period: otp.period,
                                                                     OTPKeys.issuer: otp.issuer,
                                                                     OTPKeys.label: otp.label],
                                                        privateData: [:])
            } else if let otp = otp as? HOTP {
                result = ImportOTPResult(itemId: itemId, otpType: .HOTP)
                item = ItemEnvelopeFactory.itemEnvelope(with: itemId,
                                                        type: .hotp,
                                                        identifier: [OTPKeys.secretKey: otp.secretKey.base32EncodedString,
                                                                     OTPKeys.hmacAlgorithm: otp.algorithm.rawValue,
                                                                     OTPKeys.numberOfDigits: otp.numberOfDigits,
                                                                     OTPKeys.counter: otp.counter,
                                                                     OTPKeys.issuer: otp.issuer,
                                                                     OTPKeys.label: otp.label],
                                                        privateData: [:])
            } else {
                return .failure(error: .invalidQRForOTP)
            }
            
            return .success(item: item, importOTPResult: result)
        case .failure(let error):
            return .failure(error: error)
        }
    }
}

