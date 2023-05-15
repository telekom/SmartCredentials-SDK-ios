//
//  Requests.swift
//  IdentityProvider
//
//  Created by George Cristian Cuciureanu on 05.05.2023.
//

import Foundation

class Requests {
    let networkManager = NetworkManager()
    
    public func getAccessTokenRequest(url: String, credentials: String, completion: @escaping (Result<String,Error>) -> Void) {
        let url = URL(string: url)!
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
    
    public func getBearerTokenRequest(accessToken: String, clientId: String, scope: String) {
        let bearerTokenURL = Endpoints.getBearerTokenEndpoint.url!
        let requestBody = BearerTokenRequestBody(accessToken: accessToken, bundleId: Bundle.main.bundleIdentifier, packageName: nil, clientId: clientId,scope: scope)
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(requestBody)
            let jsonString = String(data: data, encoding: .utf8)
            networkManager.postRequest(url: bearerTokenURL , body: data ) { result in
                switch result {
                case .success(let data):
                    let bearerToken = String(decoding: data, as: UTF8.self)
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
        catch {
            print(error)}
    }
}

struct BearerTokenRequestBody: Codable {
    let accessToken: String
    let bundleId: String?
    let packageName: String?
    let clientId: String
    let scope: String
}

enum Endpoint {
    case baseURL(String)
    var url: String {
        switch self {
        case .baseURL(let url):
            return url
        }
    }
}

enum Endpoints {
    
    case getAccessTokenEndpoint
    case getBearerTokenEndpoint
    case credentials
    
    var baseUrl: String {
        return "https://lbl-partmgmr.superdtaglb.cf"
    }
    var path:String {
        switch self {
        case .getAccessTokenEndpoint:
            return "/access-token"
        case .getBearerTokenEndpoint:
            return "/bearer-token-hackathon"
        case .credentials:
            return "/Odysee-45930b82-5f64-412f-9993-3456c4c61bbc"
        }
    }
    
    var endpoint: URL? {
        return URL( string: path)
    }
    var url: URL? {
        return URL( string: baseUrl+path)
    }
    var credentials: URL? {
        return URL( string: path)
    }
}
