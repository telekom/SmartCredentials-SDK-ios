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
        let url = URL(string: "https://lbl-partmgmr.superdtaglb.cf/bearer-token-hackathon")!
        let requestBody = BearerTokenRequestBody(accessToken: accessToken, bundleId: Bundle.main.bundleIdentifier, packageName: nil, clientId: clientId,scope: scope)
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(requestBody)
            let jsonString = String(data: data, encoding: .utf8)
            networkManager.postRequest(url: url , body: data ) { result in
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
