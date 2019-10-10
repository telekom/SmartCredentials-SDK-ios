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


enum WebSocketMessageEvent: String {
    case scanningQRCode = "Scanning#QRCode"
    case connectionSuccess = "Connection#Success"
    case qrAuthSuccess = "Success#QRCodeScan"
    case qrAuthFail = "Error#QRCodeScan"
}

struct WebSocketMessage {
    var event: String
    var data: QRSocketData? = nil
    
    enum CodingKeys: String, CodingKey {
        case event
        case data
    }
}

extension WebSocketMessage: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(event, forKey: .event)
        try container.encode(data, forKey: .data)
    }
}

extension WebSocketMessage: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        event = try container.decode(String.self, forKey: .event)
        data = try container.decodeIfPresent(QRSocketData.self, forKey: .data)
    }
}
