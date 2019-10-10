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

/// Constant used for populating ItemEnvelope’s identifier in a REST API call workflow.
public enum CallServiceKeys {
    /// Key for specifying the host url string of the server
    public static let host = "host"
    /// Key for specifying the end point of the server
    public static let endPoint = "end_point"
    /// Key for specifying the method type to be used
    public static let methodType = "method_type"
    /// Key for specifying the connection type to be used
    public static let connectionType = "connection_type"
    /// Key for specifying request headers
    public static let headers = "headers"
    /// Key for specifying request query parameters
    public static let queryParams = "query_params"
    /// Key for specifying request body parameters
    public static let bodyParams = "body_params"
    /// Key for specifying request body parameters' type
    public static let bodyParamsType = "body_params_type"
    /// Key for specifying certificate data used for certificate pinning (optional)
    public static let certificateData = "certificate_data"
}
