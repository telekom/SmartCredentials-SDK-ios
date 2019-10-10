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

import Starscream
import Core

typealias GetRefreshTokenCompletionHandler = (SmartCredentialsAPIResult<[String: Any]>) -> ()

class QRLoginService {
    
    var socket: WebSocket!
    
    func getRefreshTokenForQRLogin(with webSocketURL: URL,
                                   certificateData: Data?,
                                   qrCode: String,
                                   idToken: String?,
                                   refreshToken: String?,
                                   completionHandler: @escaping GetRefreshTokenCompletionHandler) {
        
        socket = WebSocket(url: webSocketURL)
        
        if let certificateData = certificateData {
            socket.security = SSLSecurity(certs: [SSLCert(data: certificateData)], usePublicKeys: true)
        }
        
        socket.onText = { (text: String) in
            guard let jsonData = text.data(using: .utf8) else {
                completionHandler(.failure(error: .invalidJSONError))
                self.socket.disconnect()
                return
            }
            
            guard let message = try? JSONDecoder().decode(WebSocketMessage.self, from: jsonData) else {
                completionHandler(.failure(error: .invalidMessageError))
                self.socket.disconnect()
                return
            }
            
            switch message.event {
            case WebSocketMessageEvent.connectionSuccess.rawValue:
                if let jsonData = qrCode.data(using: .utf8) {
                    if var qrData = try? JSONDecoder().decode(QRSocketData.self, from: jsonData) {
                        qrData.idToken = idToken
                        qrData.refreshToken = refreshToken
                        
                        let message = WebSocketMessage(event: WebSocketMessageEvent.scanningQRCode.rawValue, data: qrData)
                        self.send(message)
                    } else {
                        completionHandler(.failure(error: .invalidQRCodeReceived))
                        self.socket.disconnect()
                        return
                    }
                }
                
            case WebSocketMessageEvent.qrAuthSuccess.rawValue:
                guard let websocketReponseDictionary = text.toDictionary(),
                    let dataDictionary = websocketReponseDictionary[Constants.QRCodeLogin.responseDataKey] as? [String: Any] else {
                        completionHandler(.failure(error: .invalidAccessTokenError))
                        self.socket.disconnect()
                        return
                }
                
                completionHandler(.success(result: dataDictionary))
                self.socket.disconnect()
                
            case WebSocketMessageEvent.qrAuthFail.rawValue:
                completionHandler(.failure(error: .qrLoginFail))
                self.socket.disconnect()
                
            default:
                completionHandler(.failure(error: .invalidMessageError))
                self.socket.disconnect()
            }
        }
        
        socket.connect()
    }
    
    private func send(_ message: WebSocketMessage) {
        do {
            let json = try JSONEncoder().encode(message)
            socket.write(data: json)
        } catch {
            print(error.localizedDescription)
        }
    }
}
