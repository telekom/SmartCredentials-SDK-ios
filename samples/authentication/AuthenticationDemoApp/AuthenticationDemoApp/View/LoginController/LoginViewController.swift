//
//  LoginViewController.swift
//  AuthenticationDemoApp
//
//  Created by Camelia Ignat on 24.02.2023.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet private weak var navigationBar: NavigationBar!
    @IBOutlet private weak var loginButton: UIButton!
    
    @IBAction private func loginButtonAction(_ sender: UIButton) {
        presenter.loginButtonTapped(from: self)
    }
    
    lazy var presenter = AuthenticationPresenter(with: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    private func setupUI() {
        loginButton.layer.cornerRadius = 20
        navigationBar.title = "Authenticatin Demo"
        navigationBar.isRightButtonHidden = true
        navigationBar.isLeftButtonHidden = true
    }
}

extension LoginViewController: PresenterView {
    func showError(with error: Error) {
        showToast(error.localizedDescription)
    }
    
    func updateView(with tokens: [Token]) {
        let vc = TokensViewController.loadFromNib()
        vc.data = tokens
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false)
    }
}
