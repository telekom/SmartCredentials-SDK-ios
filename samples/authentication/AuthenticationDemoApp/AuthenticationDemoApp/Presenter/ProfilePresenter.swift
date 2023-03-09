//
//  ProfilePresenter.swift
//  AuthenticationDemoApp
//
//  Created by Camelia Ignat on 08.02.2023.
//

import Foundation
import Authentication
import UIKit

protocol ProfilePresenterView: AnyObject {
    func updateView(with user: User)
    func showError(with error: String)
    func updateProfilePicture(with image: UIImage?)
}

class ProfilePresenter {
    weak var view: ProfilePresenterView?
    
    init(with view: ProfilePresenterView) {
        self.view = view
    }
    
    func getUserInfo() {
        let currentAccessToken: String? = AuthenticationManager.shared.googleAuthService?.authState.getAccessToken()
        let userInfoEndpoint: URL? = AuthenticationManager.shared.googleAuthService?.authState.getUserInfoEndpoint()
        AuthenticationManager.shared.googleAuthService?.performAction() { (accessToken, idToken, error) in

            guard let accessToken = accessToken else {
                self.view?.showError(with: "Error getting access token")
                return
            }
            
            guard let userInfoEndpointURL = userInfoEndpoint else {
                print("Error getting accessToken")
                return
            }

            if currentAccessToken != accessToken {
                print("Access token was refreshed automatically (\(currentAccessToken ?? "CURRENT_ACCESS_TOKEN") to \(accessToken))")
            } else {
                print("Access token was fresh and not updated \(accessToken)")
            }

            var urlRequest = URLRequest(url: userInfoEndpointURL)
            urlRequest.allHTTPHeaderFields = ["Authorization":"Bearer \(accessToken)"]

            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                DispatchQueue.main.async {
                    guard error == nil else {
                        self.view?.showError(with: "HTTP request failed")
                        return
                    }

                    guard let data = data else {
                        self.view?.showError(with: "HTTP response data is empty")
                        return
                    }

                    var json: [String: Any]?

                    do {
                        json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    } catch {
                        print("JSON Serialization Error")
                    }


                    let user = User.fromJson(json)
                    self.downloadImage(from: URL(string: user.profilePicture)!)
                    DispatchQueue.main.async { [weak self] in
                        self?.view?.updateView(with: user)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    private func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                self?.view?.updateProfilePicture(with: UIImage(data: data))
            }
        }
    }
}
