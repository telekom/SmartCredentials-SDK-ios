//
//  AuthorizationPresenter.swift
//  AuthorizationDemoApp
//
//  Created by Camelia Ignat on 15.11.2022.
//

import Foundation
import Core
import Authorization

protocol PresenterView: AnyObject {
    func updateView(with authorization: Authorization)
}

class AuthorizationPresenter {
    weak var view: PresenterView?

    init(with view: PresenterView) {
        self.view = view
    }
        
    func buttonTapped() {
        let authorization = SmartCredentialsAuthorizationFactory.smartCredentialsAuthorizationAPI(configuration: SCConfiguration.sharedInstance.current)
        authorization.authorize { result in
            switch result {
            case .success:
                DispatchQueue.main.async { [weak self] in
                    self?.view?.updateView(with: .success)
                }
            case .failure(error: let error):
                DispatchQueue.main.async { [weak self] in
                    self?.view?.updateView(with: .failure)
                }
            @unknown default:
                print("Something went wrong.")
            }
        }
    }
}

