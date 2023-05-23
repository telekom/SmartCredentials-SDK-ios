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
    func request<T: Decodable>(fromURL url: URL, httpMethod: HttpMethod = .get, body: Data? = nil, completion: @escaping (Result<T, Error>) -> Void) {

        let completionOnMain: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.method
        if httpMethod == .post {
            let jsonData = try? JSONSerialization.data(withJSONObject: body as Any)
            request.httpBody = jsonData
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

            guard let data = data else { return }
            do {
                let users = try JSONDecoder().decode(T.self, from: data)
                completionOnMain(.success(users))
            } catch {
                debugPrint("Could not translate the data to the requested type. Reason: \(error.localizedDescription)")
                completionOnMain(.failure(error))
            }
        }

        urlSession.resume()
    }
}
    
enum NetworkError: Error {
    case invalidResponse
    case invalidStatusCode(Int)
    case invalidURL
}

