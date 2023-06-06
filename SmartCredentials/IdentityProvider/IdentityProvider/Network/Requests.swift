//
//  Requests.swift
//  IdentityProvider
//
//  Created by George Cristian Cuciureanu on 05.05.2023.
//

import Foundation

class Requests {
    let networkManager = NetworkManager()
    
    func getAccessToken(url: String, credentials: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: url + Endpoints.accessToken.url + "/\(credentials)") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        networkManager.request(fromURL: url) {  (result: Result<String, Error>) in
            switch result {
            case .success(let accessToken):
                completion(.success(accessToken))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getBearerToken(accessToken: String, clientId: String, scope: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let bearerTokenURL = URL(string: Endpoints.bearerToken.url) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let requestBody = BearerTokenRequestBody(accessToken: accessToken, bundleId: Bundle.main.bundleIdentifier, packageName: nil, clientId: clientId, scope: scope)
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(requestBody)
            networkManager.request(fromURL: bearerTokenURL, httpMethod: .post, body: data) {  (result: Result<String, Error>) in
                switch result {
                case .success(let bearerToken):
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
