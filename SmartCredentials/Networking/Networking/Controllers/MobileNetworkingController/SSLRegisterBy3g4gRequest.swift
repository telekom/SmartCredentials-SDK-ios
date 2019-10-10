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

import Security
import Core

protocol SSLRegisterBy3g4gRequestDelegate {
    func secureSocketRequestFinished(with response: String)
    func secureSocketRequestFinished(with error: SmartCredentialsAPIError)
}

final class SSLRegisterBy3g4gRequest: NSObject {
    
    private let port: UInt16 = 80
    private let interfaceName = HTTPMobileConstants.interfaceName
    
    private let hostURL: URL
    private let endPoint: String
    private let methodType: MethodType
    private let body: String?
    
    var delegate: SSLRegisterBy3g4gRequestDelegate?
    
    private var socket: SCGCDAsyncSocket?
    
    private var result: SmartCredentialsAPIResult<String> = .failure(error: .callServiceUnableToConnectSocket) {
        didSet {
            // Once we have a result, we check whether socket was opened
            // If it was opened, we want to disconnect the socket before continuing the flow
            // If it hasn't opened, we perform the callback immediately
            if socket != nil && socket?.isDisconnected == false {
                disconnectSocket()
            } else {
                handleResult()
            }
        }
    }
    
    // MARK: - Initializer/Deinitializer
    init(hostURL: URL, endPoint: String, methodType: MethodType, body: String?) {
        self.hostURL = hostURL
        self.endPoint = endPoint
        self.methodType = methodType
        self.body = body
        
        super.init()
    }
    
    deinit {
        // Keep the disconnect socket here in case the reference to this class stop existing, like when a back button would be pressed
        disconnectSocket()
    }
    
    // MARK: - Socket operations
    func start() {
        handleSocket()
    }
    
    func cancel() {
        // Set delegate to nil so it can't interfere with the delegate's flow
        delegate = nil
        disconnectSocket()
    }
    
    private func disconnectSocket() {
        if socket?.isDisconnected == false {
            socket?.disconnect()
        }
    }
    
    // MARK: - Private
    
    private func handleSocket() {
        socket = SCGCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.global(qos: .userInteractive))
        
        do {
            try socket?.connect(toHost: HTTPMobileConstants.host, onPort: 443, viaInterface: HTTPMobileConstants.interfaceName, withTimeout: -1)
            
            socket?.startTLS(nil)
        } catch {
            result = .failure(error: .callServiceError(error: error))
        }
    }
    
    private func handleResult() {
        switch result {
        case let .success(response):
            delegate?.secureSocketRequestFinished(with: response)
        case let .failure(error):
            delegate?.secureSocketRequestFinished(with: error)
        }
        delegate = nil
    }
}

// MARK: GCDAsyncSocketDelegate
extension SSLRegisterBy3g4gRequest: SCGCDAsyncSocketDelegate {
    func socket(_ sock: SCGCDAsyncSocket, didConnectTo url: URL) {
        print("didconnecttourl = \(url)")
    }
    
    func socket(_ sock: SCGCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        print("didConnectToHost = \(host) port = \(port)")
        
        var length = 0
        var bodyString = ""
        if body != nil {
            bodyString = body!
            length = bodyString.lengthOfBytes(using: .utf8)
        }
        
        let dataStringFormat = "%@ %@ %@\r\nHost: %@\r\nContent-Type: %@\r\nContent-Length: %d\r\n\r\n%@"
        let dataString = String(format: dataStringFormat, arguments: [methodType.rawValue, endPoint, HTTPMobileConstants.httpType, HTTPMobileConstants.host, HTTPMobileConstants.headers, length, bodyString])
        
        guard let data = dataString.data(using: .utf8) else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Unable to convert into data (invalid request data)"])
            self.result = .failure(error: .callServiceError(error: error))
            return
        }
        
        // Write data to socket
        sock.write(data, withTimeout: -1, tag: 0)
        
        // Queue socket for reading
        sock.readData(withTimeout: -1, tag: 0)
    }
    
    func socketDidDisconnect(_ sock: SCGCDAsyncSocket, withError err: Error?) {
        if let error = err {
            // An error here doesn't always mean that something went wrong. Sometimes the server disconnects you after it sent all the data it had to send
            print("Socket disconnected with error = \(error)")
        }
        handleResult()
    }
    
    func socketDidSecure(_ sock: SCGCDAsyncSocket) {
        print("Socket secured")
    }
    
    func socket(_ sock: SCGCDAsyncSocket, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> ()) {
        print("Verifying certificate")
        
        let x509Policy = SecPolicyCreateBasicX509()
        SecTrustSetPolicies(trust, x509Policy)
        
        var resultType = SecTrustResultType.invalid
        let status = SecTrustEvaluate(trust, &resultType)
        
        guard status == noErr && (resultType == .unspecified || resultType == .proceed) else {
            let description = "Certificate not trustworthy. OSStatus = \(status) result = \(resultType.rawValue)"
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: description])
            result = .failure(error: .callServiceError(error: error))
            
            completionHandler(false)
            return
        }
        
        completionHandler(true)
    }
    
    func socket(_ sock: SCGCDAsyncSocket, didWriteDataWithTag tag: Int) {
        // We wrote the data to the socket, now we have to wait to receive something via didRead delegate method
    }
    
    func socket(_ sock: SCGCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        guard let dataString = String(data: data, encoding: .utf8) else {
            let description = "Data received empty or encoding is different than .utf8"
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: description])
            result = .failure(error: .callServiceError(error: error))
            return
        }

        result = .success(result: dataString)
    }
}

enum HTTPMobileConstants {
    static let interfaceName = "pdp_ip0"
    static let host = "token-3g4g.csa.telekom-dienste.de"
    static let httpType = "HTTP/1.1"
    static let headers = "application/json"
}
