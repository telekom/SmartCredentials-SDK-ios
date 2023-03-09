//
//  MenuPresenter.swift
//  AuthenticationDemoApp
//
//  Created by Camelia Ignat on 08.02.2023.
//

import Foundation
import Authentication

protocol MenuPresenterView: AnyObject {
    func showProfilePage()
    func updateView(with tokens: [Token])
    func showBanner(with text: String)
    func showLoginPage()
    func dismissMenu()
}

class MenuPresenter {
    weak var view: MenuPresenterView?
    
    init(with view: MenuPresenterView) {
        self.view = view
    }
    
    func viewProfileTapped() {
        view?.showProfilePage()
    }
    
    func refreshTokensTapped() {
        AuthenticationManager.shared.googleAuthService?.performAction(completionHandler: { (accessToken, idToken, error) in
            
            if let error = error {
                DispatchQueue.main.async { [weak self] in
                    self?.view?.showBanner(with: error.localizedDescription)
                }
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.view?.updateView(with: Token.getTokensFromAuthService())
                self?.view?.showBanner(with: "Successfully performed action with fresh tokens")
            }
        })
    }
    
    func refreshAccessTokenTapped() {
        AuthenticationManager.shared.googleAuthService?.refreshAccessToken(completionHandler: { (accessToken, idToken, error) in
            
            if let error = error {
                DispatchQueue.main.async { [weak self] in
                    self?.view?.showBanner(with: error.localizedDescription)
                }
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.view?.updateView(with: Token.getTokensFromAuthService())
                self?.view?.showBanner(with: "Refreshed access token successfully")
            }
        })
    }
    
    func logoutTapped() {
        AuthenticationManager.shared.googleAuthService?.doLogout()
        view?.showLoginPage()
    }
}
