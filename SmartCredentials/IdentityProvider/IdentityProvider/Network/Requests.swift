//
//  Requests.swift
//  IdentityProvider
//
//  Created by George Cristian Cuciureanu on 05.05.2023.
//

import Foundation

class Requests {
    let networkManager = NetworkManager()
    
    public func getAccessTokenRequest(url: String, credentials: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(NetworkError.endpointError))
            return
        }
        
        networkManager.getRequest(url: url) { result in
            switch result {
            case .success(let data):
                let accessToken = String(decoding: data, as: UTF8.self)
                completion(.success(accessToken))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getBearerTokenRequest(accessToken: String, clientId: String, scope: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let bearerTokenURL = URL(string: Endpoints.bearerToken.url) else {
            completion(.failure(NetworkError.endpointError))
            return
        }
        
        let requestBody = BearerTokenRequestBody(accessToken: accessToken, bundleId: Bundle.main.bundleIdentifier, packageName: nil, clientId: clientId, scope: scope)
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(requestBody)
            let jsonString = String(data: data, encoding: .utf8)
            networkManager.postRequest(url: bearerTokenURL , body: data ) { result in
                switch result {
                case .success(let data):
                    let bearerToken = String(decoding: data, as: UTF8.self)
                    completion(.success(bearerToken))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
}

struct BearerTokenRequestBody: Codable {
    let accessToken: String
    let bundleId: String?
    let packageName: String?
    let clientId: String
    let scope: String
}

enum Endpoints: String {
    case accessToken
    case bearerToken
    
    private var baseUrl: String {
        return "https://lbl-partmgmr.superdtaglb.cf"
    }
    
    var url: String {
        switch self {
        case .accessToken:
            return baseUrl + "/access-token"
        case .bearerToken:
            return baseUrl + "/bearer-token-hackathon"
        }
    }
}
