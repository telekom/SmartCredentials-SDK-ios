//
//  NetworkManager.swift
//  IdentityProvider
//
//  Created by George Cristian Cuciureanu on 03.05.2023.
//

import Foundation

enum HttpMethod: String {
    case get
    case post

    var method: String { rawValue.uppercased() }
}

class NetworkManager {
    
    func request(fromURL url: URL, httpMethod: HttpMethod = .get, body: Data? = nil, completion: @escaping (Result<String, Error>) -> Void) {

        let completionOnMain: (Result<String, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.method
        if httpMethod == .post {
            request.httpBody = body
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        let urlSession = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completionOnMain(.failure(error))
                return
            }

            guard let urlResponse = response as? HTTPURLResponse else { return completionOnMain(.failure(NetworkError.invalidResponse)) }
            if !(200..<300).contains(urlResponse.statusCode) {
                return completionOnMain(.failure(NetworkError.invalidStatusCode(urlResponse.statusCode)))
            }

            guard let data = data else {
                completionOnMain(.failure(NetworkError.noData))
                return
            }
            
            let string = String(decoding: data, as: UTF8.self)

            completionOnMain(.success(string))
        }

        urlSession.resume()
    }
}
    
enum NetworkError: Error {
    case invalidResponse
    case invalidStatusCode(Int)
    case invalidURL
    case noData
}

