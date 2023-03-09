//
//  TokensViewController.swift
//  AuthenticationDemoApp
//
//  Created by Camelia Ignat on 19.01.2023.
//

import UIKit

class TokensViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: NavigationBar!
    
    var data: [Token]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        assert(data != nil)
        setupUI()
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        setupTableView()
        setupNavigationBar()
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "TokenTableViewCell", bundle: nil), forCellReuseIdentifier: "TokenTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
    }
    
    private func setupNavigationBar() {
        navigationBar.delegate = self
        navigationBar.title = "Authentication Demo"
        navigationBar.isLeftButtonHidden = true
    }
}

extension TokensViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TokenTableViewCell") as? TokenTableViewCell else {
            return UITableViewCell()
        }
        
        cell.setupUI(with: data![indexPath.row])
        
        return cell
    }
}

extension TokensViewController: NavigationBarProtocol {
    func didPressRightButton() {
        let vc = MenuViewController.loadFromNib()
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        self.present(vc, animated: false)
    }
}
extension TokensViewController: MenuDelegate {
    func showProfilePage() {
        let vc = ProfileViewController.loadFromNib()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false)
    }
    
    func updateView(with tokens: [Token]) {
        data = tokens
        tableView.reloadData()
    }
    
    func showBanner(with text: String) {
        showToast(text)
    }
    
    func showLoginPage() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let window = windowScenes?.windows.first
        
        if let viewController = window?.rootViewController, viewController.isKind(of: LoginViewController.self) {
            self.dismiss(animated: false)
        } else {
            let viewController = LoginViewController.loadFromNib()
            window?.rootViewController = viewController
        }
    }
}
