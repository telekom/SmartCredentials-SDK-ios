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

public typealias GETOTPCompletionHandler = (SmartCredentialsAPIResult<OTPCode>) -> ()
public typealias ImportOTPItemCompletionHandler = (SmartCredentialsAPIResult<ImportOTPResult>) -> ()

public protocol OTPAPI {
    
    /// Adds user account for generating OTP code into the library
    ///
    /// - Parameter item: item envelope containing secret key and other otp parameters
    /// - Returns: Enum; success - void; failure - SmartCredentialsAPIError (enum)
    func addOTPItemAccount(_ item: ItemEnvelope) -> SmartCredentialsAPIEmptyResult
    
    /// Imports OTP Item via QR for generating OTP code into the library
    ///
    /// - Parameters:
    ///   - containerView: view in which the barcode scanner will be displayed
    ///   - itemId: id of the importing otp item
    ///   - completionHandler: completion handler with result as parameter (.success with itemId and otp type or .failure with associated error)
    func importOTPItemViaQR(in containerView: UIView, for itemId: String, completionHandler: @escaping ImportOTPItemCompletionHandler)
    
    /// Gets the HOTP code for a specific account
    ///
    /// - Parameter itemFilter: used for specifying account id
    /// - Returns: Generic enum; success - string object representing HOTP code; failure - SmartCredentialsAPIError (enum)
    func getHOTPCode(for itemFilter: ItemFilter) -> SmartCredentialsAPIResult<String>
    
    /// Start TOTP code generation
    ///
    /// - Parameters:
    ///   - itemFilter: used for specifying account id
    ///   - completionHandler: completion handler with result as parameter (.success with generated hotp code or .failure with associated error)
    /// - Note: Completion handler will be called once every x seconds (default period is 30 seconds)
    /// - Returns: Void
    func startTOTPGenereration(for itemFilter: ItemFilter, completionHandler: @escaping GETOTPCompletionHandler)
    
    /// Stops TOTP code generation
    ///
    /// - Parameter itemFilter: used for specifying account id
    /// - Returns: Enum; success - void; failure - SmartCredentialsAPIError (enum)
    func stopTOTPGeneration(for itemFilter: ItemFilter) -> SmartCredentialsAPIEmptyResult
}
