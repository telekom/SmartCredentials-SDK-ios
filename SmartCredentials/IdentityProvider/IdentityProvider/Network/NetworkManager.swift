//
//  NetworkManager.swift
//  IdentityProvider
//
//  Created by George Cristian Cuciureanu on 03.05.2023.
//

import Foundation

class NetworkManager: NetworkManagerProtocol {
    func getRequest(url: URL, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            guard let data = data else {
                completionHandler(.failure(NetworkError.noData))
                return
            }
            completionHandler(.success(data))
        }.resume()
    }
    
    func postRequest(url: URL, body: Data, completion: @escaping (Result<Data, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            completion(.success(data))
        }.resume()
    }
}

protocol NetworkManagerProtocol {
    func getRequest(url: URL, completionHandler: @escaping (Result<Data,Error>) -> Void)
    func postRequest(url: URL, body: Data, completion: @escaping (Result<Data,Error>) -> Void)
}
    
enum NetworkError: Error {
    case noData
    case endpointError
}

