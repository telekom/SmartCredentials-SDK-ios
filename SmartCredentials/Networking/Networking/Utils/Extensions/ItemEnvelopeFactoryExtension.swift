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

#if canImport(Core)
import Core
#endif

extension ItemEnvelopeFactory {
    public static func itemEnvelopeForRESTAPICall(with id: String,
                                                  host: String,
                                                  endPoint: String,
                                                  methodType: MethodType,
                                                  connectionType: ConnectionType,
                                                  headers: [String: String],
                                                  queryParams: [String: Any],
                                                  bodyParams: String? = nil,
                                                  bodyType: BodyParamsType? = nil,
                                                  certificateData: Data? = nil) -> ItemEnvelope {
        let itemPrivateData = ItemPrivateData(privateData: [:])
        let itemMetadata = ItemMetadata(channel: .type1D, actionList: [], itemPrivateData: itemPrivateData, isLocked: false, autoLocked: false)
        var identifier: [String: Any] = [CallServiceKeys.host: host,
                                         CallServiceKeys.endPoint: endPoint,
                                         CallServiceKeys.methodType: methodType,
                                         CallServiceKeys.connectionType: connectionType,
                                         CallServiceKeys.headers: headers,
                                         CallServiceKeys.queryParams: queryParams]
        
        if let bodyParams = bodyParams {
            identifier[CallServiceKeys.bodyParams] = bodyParams
        }
        
        if let bodyParamsType = bodyType {
            identifier[CallServiceKeys.bodyParamsType] = bodyParamsType
        }
        
        if let certificateData = certificateData {
            identifier[CallServiceKeys.certificateData] = certificateData
        }
        
        LoggerProvider.sharedInstance.logger?.log(.objectCreated, message: Constants.Logger.itemEnvelopeRestAPIObjectCreated,
                                                  className: String(describing: type(of: self)))
        
        return ItemEnvelope(identifier: identifier,
                            itemId: id,
                            itemType: .other,
                            itemMetadata: itemMetadata)
    }
}
