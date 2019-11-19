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

extension SmartCredentialsAPIError: Equatable {
    static public func ==(lhs: SmartCredentialsAPIError, rhs: SmartCredentialsAPIError) -> Bool {
        switch (lhs, rhs) {
        case let (.callServiceError(error: errorA), .callServiceError(error: errorB)):
            return errorA.localizedDescription == errorB.localizedDescription
        
        case let (.generatingKeysFailed(osStatus: osStatusA), .generatingKeysFailed(osStatus: osStatusB)):
            return osStatusA == osStatusB
            
        case (.saveError, .saveError),
             (.itemNotFound, .itemNotFound),
             (.invalidItemFilter, .invalidItemFilter),
             (.jailbreakDetected, .jailbreakDetected),
             (.authFailed, .authFailed),
             (.authUserCancel, .authUserCancel),
             (.authAppCancel, .authAppCancel),
             (.authSystemCancel, .authSystemCancel),
             (.invalidJSONError, .invalidJSONError),
             (.invalidMessageError, .invalidMessageError),
             (.invalidQRCodeReceived, .invalidQRCodeReceived),
             (.invalidWebSocketURLReceived, .invalidWebSocketURLReceived),
             (.invalidAccessTokenError, .invalidAccessTokenError),
             (.qrLoginFail, .qrLoginFail),
             (.invalidItemForOTP, .invalidItemForOTP),
             (.invalidQRForOTP, .invalidQRForOTP),
             (.noTOTPRunning, .noTOTPRunning),
             (.invalidItemForCallService, .invalidItemForCallService),
             (.invalidURLForCallService, .invalidURLForCallService),
             (.callServiceFailed, .callServiceFailed),
             (.callServiceUnableToConnectSocket, .callServiceUnableToConnectSocket),
             (.scanNotSupported, .scanNotSupported),
             (.invalidMicroBlinkLicense, .invalidMicroBlinkLicense),
             (.moduleNotAvailable, .moduleNotAvailable),
             (.actionNotFound, .actionNotFound),
             (.retrievingConfiguration, .retrievingConfiguration),
             (.invalidIssuer, .invalidIssuer),
             (.invalidRedirectURI, .invalidRedirectURI),
             (.invalidClientID, .invalidClientID),
             (.authRegistrationFailed, .authRegistrationFailed),
             (.authorizationError, .authorizationError),
             (.invalidRegistrationResponse, .invalidRegistrationResponse),
             (.invalidAuthServiceURL, .invalidAuthServiceURL),
             (.invalidScope, .invalidScope),
             (.confirmationActionExecution, .confirmationActionExecution):
            return true
        default:
            return false
        }
    }
}