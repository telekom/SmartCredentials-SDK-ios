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
import Core

public struct SmartCredentialsNetworkingFactory
{
    
    static var wifiNetwokingModule: NetworkingAPI?
    static var mobileNetworkingModule: NetworkingAPI?
    
    /// Creates NetworkingAPI object instance based on connection type and configuration received
    ///
    /// - Parameter contentType: conection type (Wifi / mobile)
    /// - Returns: NetworkingController object
    public static func smartCredentialsNetworkingAPI(for configuration: SmartCredentialsConfiguration,
                                              connectionType: ConnectionType) -> NetworkingAPI {
        
        if connectionType == .any || connectionType == .overWiFi {
            wifiNetwokingModule = WiFiNetworkingController(configuration: configuration)
            return wifiNetwokingModule!
        } else {
            mobileNetworkingModule = MobileNetworkingController(configuration: configuration)
            return mobileNetworkingModule!
        }
    }
}

