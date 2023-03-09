//
//  ViewController.swift
//  AuthorizationDemoApp
//
//  Created by Camelia Ignat on 15.11.2022.
//

import UIKit
import Core
import Authorization

final class ViewController: UIViewController {
    @IBOutlet private weak var navigationBar: NavigationBar!
    @IBOutlet private weak var authorizationImageView: UIImageView!
    @IBOutlet private weak var authorizationLabel: UILabel!
    @IBOutlet private weak var authorizeButton: UIButton!
    
    @IBAction private func authorizeButtonAction(_ sender: UIButton) {
        presenter.buttonTapped()
    }
    
    lazy var presenter = AuthorizationPresenter(with: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNavigationBar()
    }

    private func setupUI() {
        authorizeButton.layer.cornerRadius = 20
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationBar.title = "AuthorizationDemo"
    }
}

extension ViewController: PresenterView {
    func updateView(with authorization: Authorization) {
        authorizationLabel.text = authorization.text
        authorizationImageView.image = authorization.image
        authorizationImageView.tintColor = authorization == .success ? UIColor(named: "mainColor") : UIColor.gray
    }
}

class SCConfiguration {
    static let sharedInstance = SCConfiguration()
    let current = SmartCredentialsConfiguration(userId: "user")
}
