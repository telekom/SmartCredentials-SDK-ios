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

class WiFiNetworkingController {
    
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
extension WiFiNetworkingController: NetworkingAPI {
    func callService(with hostURL: URL,
                     endPoint: String,
                     methodType: MethodType,
                     headers: [String: String],
                     queryParams: [String: Any],
                     bodyParams: String?,
                     bodyParamsType: BodyParamsType?,
                     certificateData: Data?,
                     completionHandler: @escaping CallServiceCompletionHandler) {
        guard isJailbroken() == false else {
            logger?.log(.error, message: Constants.Logger.jailbreakError, className: className)
            completionHandler(.failure(error: .jailbreakDetected))
            return
        }
        
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfiguration, delegate: nil, delegateQueue: OperationQueue.main)
        
        var url = hostURL.appendingPathComponent(endPoint)
        url.appendQueryParameters(queryParams)
        
        var request = URLRequest(url: url)
        
        for (headerField, headerValue) in headers {
            request.addValue(headerValue, forHTTPHeaderField: headerField)
        }
        
        request.httpMethod = methodType.rawValue
        
        if let bodyParamsType = bodyParamsType {
            switch bodyParamsType {
            case .json:
                if let bodyParams = bodyParams {
                    if let body = try? JSONSerialization.data(withJSONObject: [bodyParams], options: []) {
                        request.httpBody = body
                    }
                }
            case .text:
                request.httpBody = bodyParams?.data(using: .utf8)
            @unknown default:
                // Any future cases not recognized by the compiler yet
                break
            }
        }
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error: .callServiceError(error: error)))
                return
            }
            
            completionHandler(.success(result: data))
        }
        
        dataTask.resume()
    }
}

extension WiFiNetworkingController: Nameable {
}
