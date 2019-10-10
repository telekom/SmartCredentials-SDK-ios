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


/// Constant used for populating ItemEnvelope’s identifier in an QR Login workflow.
public enum QRLoginKeys {
    /// Key for specifying the qr code read by QR Scanner
    public static let qrCode = "qr_code"
    /// Key for specifying the id token
    public static let idToken = "id_token"
    /// Key for specifying the refresh token
    public static let refreshToken = "refresh_token"
    /// Key for specifying certificate data used for certificate pinning (optional)
    public static let certificateData = "certificate_data"
    /// Key for specifying the websocket url
    public static let webSocketURL = "websocket_url"
}
