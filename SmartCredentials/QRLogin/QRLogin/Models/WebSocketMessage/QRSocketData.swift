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


struct QRSocketData {
    
    var browserClient: String?
    var qrId: String?
    var idToken: String?
    var refreshToken: String?
    
    
    enum CodingKeys: String, CodingKey {
        case qrId = "qr_uuid"
        case browserClient
        case idToken = "id_token"
        case refreshToken = "refresh_token"
    }
}

extension QRSocketData: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(browserClient, forKey: .browserClient)
        try container.encode(qrId, forKey: .qrId)
        try container.encode(idToken, forKey: .idToken)
        try container.encode(refreshToken, forKey: .refreshToken)
    }
}

extension QRSocketData: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        browserClient = try container.decodeIfPresent(String.self, forKey: .browserClient)
        qrId = try container.decodeIfPresent(String.self, forKey: .qrId)
        idToken = try container.decodeIfPresent(String.self, forKey: .idToken)
        refreshToken = try container.decodeIfPresent(String.self, forKey: .refreshToken)
    }
}
