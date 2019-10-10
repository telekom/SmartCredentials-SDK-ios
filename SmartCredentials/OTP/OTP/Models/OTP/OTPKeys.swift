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


/// Constant used for populating ItemEnvelope’s identifier in an OTP workflow.
public enum OTPKeys {
    //@OTP
    /// Key for specifying the HMAC algorithm to be used in the OTP generation
    public static let hmacAlgorithm = "hmac_algorithm"
    
    /// Key for specifying the number of digits of the OTP generated code
    public static let numberOfDigits = "number_of_digits"
    
    /// Key for specifying the secret key’s data to be used in the OTP generation
    public static let secretKey = "secret_key"

    /// Key for specifying the issuer of the OTP
    public static let issuer = "issuer"

    /// Key for specifying the label of the OTP
    public static let label = "label"
    
    // HOTP
    /// Key for specifying the counter starting value in the HOTP generation
    public static let counter = "counter"
    
    // TOTP
    /// Key for specifying the number of seconds after the generated TOTP code will expire
    public static let period = "period"
}
