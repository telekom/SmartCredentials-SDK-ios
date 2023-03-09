//
//  ProfileViewController.swift
//  AuthenticationDemoApp
//
//  Created by Camelia Ignat on 07.02.2023.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var profileNameLabel: UILabel!
    @IBOutlet private weak var givenNameLabel: UILabel!
    @IBOutlet private weak var familyNameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var localeLabel: UILabel!
    @IBOutlet private weak var navigationBar: NavigationBar!
    @IBOutlet private weak var checkmarkImageView: UIImageView!
    @IBOutlet private weak var failureView: UIView!
    
    lazy var presenter = ProfilePresenter(with: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.getUserInfo()
        setupUI()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        setupNavigationBar()
        failureView.isHidden = true
        checkmarkImageView.isHidden = true
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
    }
    
    private func setupNavigationBar() {
        navigationBar.title = "Profile"
        navigationBar.isRightButtonHidden = true
        navigationBar.delegate = self
    }
}

extension ProfileViewController: ProfilePresenterView {
    func updateProfilePicture(with image: UIImage?) {
        profileImageView.image = image
    }
    
    func updateView(with user: User) {
        failureView.isHidden = true
        profileNameLabel.text = user.name
        givenNameLabel.text = user.givenName
        familyNameLabel.text = user.familyName
        emailLabel.text = user.email
        localeLabel.text = user.locale
        checkmarkImageView.isHidden = user.emailVerified ? false : true
    }
    
    func showError(with error: String) {
        failureView.isHidden = false
        showToast(error)
    }
}

extension ProfileViewController: NavigationBarProtocol {
    func didPressLeftButton() {
        self.dismiss(animated: false)
    }
}
