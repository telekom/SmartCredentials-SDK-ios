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

import Core

class MobileNetworkingController {
    
    let logger = LoggerProvider.sharedInstance.logger
    var configuration: SmartCredentialsConfiguration
    
    var completionHandler: CallServiceCompletionHandler?
    var mobileRequest: SSLRegisterBy3g4gRequest?
    
    // MARK: - Initializers
    public init(configuration: SmartCredentialsConfiguration) {
        self.configuration = configuration
    }
    
    // MARK: - Jailbreak Check
    private func isJailbroken() -> Bool {
        if configuration.jailbreakCheckEnabled {
            return JailbreakDetection.isJailbroken()
        }
        return false
    }
}

// MARK: - Networking API
extension MobileNetworkingController: NetworkingAPI {
    func callService(with hostURL: URL,
                     endPoint: String,
                     methodType: MethodType,
                     headers: [String : String],
                     queryParams: [String : Any],
                     bodyParams: String?,
                     bodyParamsType: BodyParamsType?,
                     certificateData: Data?,
                     completionHandler: @escaping CallServiceCompletionHandler) {
        guard isJailbroken() == false else {
            logger?.log(.error, message: Constants.Logger.jailbreakError, className: className)
            completionHandler(.failure(error: .jailbreakDetected))
            return
        }
        
        self.completionHandler = completionHandler
        mobileRequest = SSLRegisterBy3g4gRequest(hostURL: hostURL,
                                                     endPoint: endPoint,
                                                     methodType: methodType,
                                                     body: bodyParams)
        mobileRequest?.delegate = self
        
        mobileRequest?.start()
    }
}

extension MobileNetworkingController: SSLRegisterBy3g4gRequestDelegate {
    func secureSocketRequestFinished(with response: String) {
        completionHandler?(.success(result: response))
    }
    
    func secureSocketRequestFinished(with error: SmartCredentialsAPIError) {
        completionHandler?(.failure(error: error))
    }
}

extension MobileNetworkingController: Nameable {
}
