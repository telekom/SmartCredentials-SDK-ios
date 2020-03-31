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

public class CallServiceAction: IActionModule {
    
    // MARK: - Initializer
    public required init(actionId: String, moduleName: String, data: [String : Any]) {
        super.init(actionId: actionId, moduleName: moduleName, data: data)
    }
    
    // MARK: - Execute
    public override func execute(with item: ItemEnvelope, completionHandler: @escaping ExecCallCompletionHandler) {
        
        guard let connectionTypeString = data[CallServiceKeys.connectionType] as? String,
            let connectionType = ConnectionType(rawValue: connectionTypeString) else {
                completionHandler(.failure(error: CallServiceActionError.connectionTypeInvalid))
                return
        }
        
        guard let networkingController = networkingController(for: connectionType) else {
            completionHandler(.failure(error: SmartCredentialsAPIError.moduleNotInitialized))
            return
        }
        
        guard let hostURLString = data[CallServiceKeys.host] as? String,
            let hostURL = URL(string: hostURLString) else {
                completionHandler(.failure(error: CallServiceActionError.hostURLInvalid))
                return
        }
        
        guard let endPoint = data[CallServiceKeys.endPoint] as? String else {
            completionHandler(.failure(error: CallServiceActionError.endPointInvalid))
            return
        }
        
        guard let methodTypeString = data[CallServiceKeys.methodType] as? String,
            let methodType = MethodType(rawValue: methodTypeString) else {
                completionHandler(.failure(error: CallServiceActionError.methodTypeInvalid))
                return
        }
        
        let privataData = item.itemMetadata.itemPrivateData.privateData
        var bodyParamsType: BodyParamsType? = nil
        if let bodyParamsTypeString = privataData[CallServiceKeys.bodyParamsType] as? String {
            bodyParamsType = BodyParamsType(rawValue: bodyParamsTypeString)
        }
        
        var headers: [String: String] = [:]
        if let headersDict = privataData[CallServiceKeys.headers] as? [String: String] {
            headers = headersDict
        }
        
        var queryParams: [String: Any] = [:]
        if let queryParamsDict = privataData[CallServiceKeys.queryParams] as? [String: Any] {
            queryParams = queryParamsDict
        }
        
        networkingController.callService(with: hostURL,
                                         endPoint: endPoint,
                                         methodType: methodType,
                                         headers: headers,
                                         queryParams: queryParams,
                                         bodyParams: privataData[CallServiceKeys.bodyParams] as? String,
                                         bodyParamsType: bodyParamsType,
                                         certificateData: privataData[CallServiceKeys.certificateData] as? Data,
                                         completionHandler: { result in
                                            self.handleCallService(result, completionHandler: completionHandler)
        })
    }
    
    private func networkingController(for connectionType: ConnectionType) -> NetworkingAPI? {
        if connectionType == .any || connectionType == .overWiFi {
            return SmartCredentialsNetworkingFactory.wifiNetwokingModule
        } else {
            return SmartCredentialsNetworkingFactory.mobileNetworkingModule
        }
    }
    
    private func handleCallService(_ result: SmartCredentialsAPIResult<Any?>, completionHandler: ExecCallCompletionHandler) {
        switch result {
        case .success(let result):
            completionHandler(.success(result: result))
        case .failure(let scError):
            switch scError {
            case .invalidURLForCallService:
                completionHandler(.failure(error: CallServiceActionError.urlInvalid))
            case .callServiceFailed:
                completionHandler(.failure(error: CallServiceActionError.callServiceFailed))
            case .callServiceUnableToConnectSocket:
                completionHandler(.failure(error: CallServiceActionError.callServiceUnableToConnectSocket))
            case .callServiceError(let error):
                completionHandler(.failure(error: CallServiceActionError.callServiceError(error: error)))
            default:
                completionHandler(.failure(error: CallServiceActionError.callServiceFailed))
            }
        @unknown default:
            // Any future cases not recognized by the compiler yet
            break
        }
    }
}

enum CallServiceActionError: Error {
    
    /**
     Error received if the connection type is not specified in the action's data
     */
    case connectionTypeInvalid
    
    /**
     Error received if the host url is not specified in the action's data
     */
    case hostURLInvalid
    
    /**
     Error received if the end point is not specified in the action's data
     */
    case endPointInvalid
    
    /**
     Error received if the method type is not specified in the action's data
     */
    case methodTypeInvalid
    
    /**
     Error received if the endpoint or host url specified in incorrect
     */
    case urlInvalid
    
    /**
     Error received if the call service action failed to execute
     */
    case callServiceFailed
    
    /**
     Error received if the call service action failed to connect to socket
     */
    case callServiceUnableToConnectSocket
    
    /**
     General call service action failure with parameter
     */
    case callServiceError(error: Error)
}
