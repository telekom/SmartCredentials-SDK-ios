//
//  AuthenticationPresenter.swift
//  AuthenticationDemoApp
//
//  Created by Camelia Ignat on 09.01.2023.
//

import Foundation
import UIKit
import Core

protocol PresenterView: AnyObject {
    func updateView(with tokens: [Token])
    func showError(with error: Error)
}

class AuthenticationPresenter {
    weak var view: PresenterView?
    

    init(with view: PresenterView) {
        self.view = view
    }
    
    func loginButtonTapped(from viewController: UIViewController) {
        AuthenticationManager.shared.doLogin(with: viewController) { (result) in
           
            switch result {
            case .success:
                self.view?.updateView(with: Token.getTokensFromAuthService())
            case .failure(error: let error):
                self.view?.showError(with: error)
            }
        }
    }
}
