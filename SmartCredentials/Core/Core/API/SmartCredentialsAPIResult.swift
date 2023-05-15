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

/// Enum used for representing success or error when there exists an object to be received in case of a successfull call
public enum SmartCredentialsAPIResult<T> {
    /**
     Success value received in case of a successful api call
     */
    case success(result: T)
    
    /**
     Failure value (with SmartCredentialsAPIError value associated) received in case of an unsuccessful api call
     */
    case failure(error: SmartCredentialsAPIError)
}

/// Enum used for representing success or error when there is no object to be received in case of a successfull call
public enum SmartCredentialsAPIEmptyResult {
    /**
     Success value received in case of a successful api call
     */
    case success
    
    /**
     Failure value (with ItemStoreError value associated) received in case of an unsuccessful api call
     */
    case failure(error: SmartCredentialsAPIError)
}

/// Enum used for representing SmartCredentials API errors
public enum SmartCredentialsAPIError: Error {
    /**
     Error received in case of an unsuccessful save item operation
     */
    case saveError
    
    /**
     Error received when there is no item with the specified itemId in the library’s database
     */
    case itemNotFound
    
    /**
     Error received when an invalid item filter was used to get a specific item from the library
     */
    case invalidItemFilter
    
    /**
     Error received when the library is called but the device is jailbroken
     */
    case jailbreakDetected
    
    /**
     Error received in case of an unsuccessful authorization process
     */
    case authFailed
    
    /**
     Error received when the user cancels the authorization process
     */
    case authUserCancel
    
    /**
     Error received when the application cancels the authorization process
     */
    case authAppCancel
    
    /**
     Error received when the system cancels the authorization process
     */
    case authSystemCancel
    
    //@OCR Scanner
    /**
     Error received in case on an unsuccessful G8Tesseract object initialization
     */
    case initTesseractError
    
    /**
     Error received when user cancels the open camera permission (OCR Scanner)
     */
    case openCameraAccessDenied

    /**
     Error received when capture device cannot be initialized (OCR Scanner)
    */
    case createCaptureDeviceError
    
    /**
     Error received when capture device input cannot be initialized (OCR Scanner)
     */
    case createCaptureDeviceInputError
    
    /**
     Error received when device input cannot be added to capture session (OCR Scanner)
     */
    case addDeviceInputError
    
    /**
     Error received when video data output cannot be added to capture session (OCR Scanner)
     */
    case addVideoDataOutputError
    
    /**
     Error received after 20 tries of matching the format text searched in the image scanned (OCR Scanner with parser enabled)
     */
    case formatNotFoundError
    
    //@QR Code Login
    /**
     Error received in case of receiving invalid json format throught websocket (QR Code Login)
     */
    case invalidJSONError
    
    /**
     Error received in case of receiving invalid message format throught websocket (QR Code Login)
     */
    case invalidMessageError
    
    /**
     Error received when an invalid item envelope was used to login using QR (QR Code Login)
     */
    case invalidQRCodeReceived
    
    /**
     Error received when an invalid websocket url was used to login using QR (QR Code Login)
     */
    case invalidWebSocketURLReceived
    
    /**
     Error received when auth was successful, but received invalid access token through websocket (QR Code Login)
     */
    case invalidAccessTokenError
    
    /**
     Error received in case of un unsuccessful QR Login (QR Code Login)
     */
    case qrLoginFail
    
    case invalidItemForOTP
    case invalidQRForOTP
    case noTOTPRunning
    
    //@CallService
    case invalidItemForCallService
    case invalidURLForCallService
    case callServiceFailed
    case callServiceUnableToConnectSocket
    case callServiceError(error: Error)
    
    //@CryptographicKeys
    case generatingKeysFailed(osStatus: OSStatus)
    case encryptingTextFailed(osStatus: OSStatus)
    
    //@MicroBlink
    /**
     Error received if scanning is not supported in MicroBlink
    */
    case scanNotSupported
    
    /**
     Error received if the MicroBlink license key is invalid
     */
    case invalidMicroBlinkLicense
    
    /**
     Error received if the called module is not available
     */
    case moduleNotAvailable
    
    /**
     Error received if no action was found on item's metadata
     */
    case actionNotFound
    
    /**
     Error received if no ConfirmationAction was found on item's metadata and the item is locked or auto-locked
     */
    case noConfirmationActionFound
    
    /**
     Error recieved in case of a failure automatic execution of ConfirmationAction (in case of locked items)
     */
    case confirmationActionExecution
    
    //@AuthService
    /**
     Error received if configuration data cannot retrieve discovery document
     */
    case retrievingConfiguration
    
    /**
     Error creating URL for issuer
     */
    case invalidIssuer
    
    /**
     Error creating URL for redirectURI
     */
    case invalidRedirectURI
    
    /**
     Error while using clientID
     */
    case invalidClientID
    
    /**
     Error received if registration failed
     */
    case authRegistrationFailed
    
    /**
     Error received if authorization failed
     */
    case authorizationError
    
    /**
     Error received if the response from registration processs (part of login flow) is invalid
     */
    case invalidRegistrationResponse

    /**
     Error received if creating URL for redirectURI failed
     */
    case invalidAuthServiceURL
    
    /**
     Error received if scope is not given
     */
    case invalidScope
    
    
    case moduleNotInitialized
    
    /**
     Error received if Smart Agent returns an empty operator token
     */
    case invalidOperatorToken
    
    /**
     Error received if the user press cancel in Smart Agent when the operator token is received
     */
    case operatorTokenUserCancellation
}

