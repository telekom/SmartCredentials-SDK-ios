//
//  MobileNetworkingController.swift
//  SmartCredentialsLibrary
//
//  Created by Catalin Haidau on 03/07/2018.
//  Copyright © 2018 Deutsche Telekom. All rights reserved.
//


class MobileNetworkingController: NetworkingAPI {
    
    var completionHandler: CallServiceCompletionHandler?
    var mobileRequest: SSLRegisterBy3g4gRequest?
    
    func callService(with hostURL: URL,
                     endPoint: String,
                     methodType: MethodType,
                     headers: [String : String],
                     queryParams: [String : Any],
                     bodyParams: String?,
                     bodyParamsType: BodyParamsType?,
                     certificateData: Data?,
                     completionHandler: @escaping CallServiceCompletionHandler) {
        self.completionHandler = completionHandler
        mobileRequest = SSLRegisterBy3g4gRequest(hostURL: hostURL,
                                                     endPoint: endPoint,
                                                     methodType: methodType,
                                                     body: bodyParams)
        mobileRequest?.delegate = self
        
        mobileRequest?.start()
    }
}

extension HTTPMobileHandler: SSLRegisterBy3g4gRequestDelegate {
    func secureSocketRequestFinished(with response: String) {
        completionHandler?(.success(result: response))
    }
    
    func secureSocketRequestFinished(with error: SmartCredentialsAPIError) {
        completionHandler?(.failure(error: error))
    }
}
