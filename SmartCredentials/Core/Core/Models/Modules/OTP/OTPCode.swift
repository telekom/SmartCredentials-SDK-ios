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

/// Enum representing one-time password type (HOTP or TOTP).
public enum OTPType {
    /// Value representing HMAC-based One-time password
    case HOTP
    /// Value representing Time-based One-time password
    case TOTP
}

/// Object representing the result of the OTP generation
public struct OTPCode {
    
    /// String object representing the OTP code
    public let code: String
    
    /// OTPType enum representing the type of the OTP
    public let type: OTPType
    
    /// Integer representing the number of seconds remained until the generated code will expire (TOTP only)
    public var remainingSeconds: Int? = nil
    
    public var counter: Int? = nil
    
    public init(hotpCode: String, counter: Int) {
        self.code = hotpCode
        self.type = .HOTP
        self.counter = counter
    }
    
    public init(totpCode: String, remainingSeconds: Int) {
        self.code = totpCode
        self.type = .TOTP
        self.remainingSeconds = remainingSeconds
    }
}
