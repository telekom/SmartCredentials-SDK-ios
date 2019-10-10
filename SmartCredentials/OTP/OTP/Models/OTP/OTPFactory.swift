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


struct OTPFactory {
    
    static func otp(from urlComponents: URLComponents) -> OTP? {
        if urlComponents.scheme != "otpauth" || urlComponents.host == nil {
            return nil
        }

        guard let query = urlComponents.queryItems else {
            return nil
        }
        
        var period: Int = 30
        var counter: Int = 0
        var algorithm: HMACAlgorithm = .SHA1
        var digits: Int = 6
        var secret: Data!
        
        for item: URLQueryItem in query {
            if item.value == nil { continue }
            
            switch item.name.lowercased() {
            case "period":
                if let tmp = Int(item.value!) {
                    if tmp < 5 {
                        return nil
                    }
                    
                    period = tmp
                }
                
            case "counter":
                if let tmp = Int(item.value!) {
                    if tmp < 0 {
                        return nil
                    }
                    
                    counter = tmp
                }
            
            case "secret":
                if let s = item.value!.base32DecodedData {
                    secret = s
                } else {
                    return nil
                }
                
            case "algorithm":
                switch item.value!.lowercased() {
                case "md5":
                    algorithm = .MD5
                case "sha1":
                    algorithm = .SHA1
                case "sha224":
                    algorithm = .SHA224
                case "sha256":
                    algorithm = .SHA256
                case "sha384":
                    algorithm = .SHA384
                case "sha512":
                    algorithm = .SHA512
                default:
                    return nil
                }
                
            case "digits":
                switch item.value! {
                case "6":
                    digits = 6
                case "8":
                    digits = 8
                default:
                    return nil
                }

            default:
                continue
            }
        }
        
        guard secret != nil else {
            return nil
        }
        
        // Normalize path
        var issuer = ""
        var label = ""
        var path = urlComponents.path
        while path.hasPrefix("/") {
            path = String(path[path.index(path.startIndex, offsetBy: 1)...])
        }
        if path != "" {
            let comps = path.components(separatedBy: ":")
            issuer = comps[0]
            label = comps.count > 1 ? comps[1] : ""
        }

        switch urlComponents.host!.lowercased() {
        case "totp":
            let totp = TOTP(algorithm: algorithm, numberOfDigits: digits, secretKey: secret, period: period)
            totp.issuer = issuer
            totp.label = label
            return totp
        case "hotp":
            let hotp = HOTP(algorithm: algorithm, numberOfDigits: digits, secretKey: secret, counter: counter)
            hotp.issuer = issuer
            hotp.label = label
            return hotp
        default:
            return nil
        }
    }
}
