//
//  MenuViewController.swift
//  AuthenticationDemoApp
//
//  Created by Camelia Ignat on 07.02.2023.
//

import UIKit

protocol MenuDelegate: AnyObject {
    func showProfilePage()
    func updateView(with tokens: [Token])
    func showBanner(with text: String)
    func showLoginPage()
}

final class MenuViewController: UIViewController {
    @IBOutlet weak private var tableView: UITableView!
        
    lazy var presenter = MenuPresenter(with: self)
    var delegate: MenuDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib.init(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuTableViewCell")
        
        tableView.backgroundColor = .clear
        tableView.layer.masksToBounds = false
        tableView.layer.shadowOpacity = 0.2
        tableView.layer.shadowOffset = CGSize(width: -3, height: 3)
        tableView.layer.shadowColor = UIColor.black.cgColor
        addTapGesture()
        view.bringSubviewToFront(tableView)
    }
    
    // MARK: - Private methods
    private func addTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        tapGestureRecognizer.cancelsTouchesInView = false
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
    }

       
    @objc private func didTapView() {
        dismiss(animated: false)
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuList.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as? MenuTableViewCell else {
            return UITableViewCell()
        }
        cell.titleLabel.text = MenuList.allCases[indexPath.row].rawValue
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tableView.cellForRow(at: indexPath) is MenuTableViewCell else {
            return
        }
        
        switch MenuList.allCases[indexPath.row] {
        case .userProfile:
            presenter.viewProfileTapped()
        case .refreshTokens:
            presenter.refreshTokensTapped()
        case .refreshAccessToken:
            presenter.refreshAccessTokenTapped()
        case .logout:
            presenter.logoutTapped()
        }
    }
}

extension MenuViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
            if touch.view?.isDescendant(of: self.tableView) == true {
                return false
            }
            return true
        }
}

extension MenuViewController: MenuPresenterView {
    func showProfilePage() {
        dismiss(animated: false)
        delegate?.showProfilePage()
    }
    
    func updateView(with tokens: [Token]) {
        dismiss(animated: false)
        delegate?.updateView(with: tokens)
    }
    
    func showBanner(with text: String) {
        dismiss(animated: false)
        delegate?.showBanner(with: text)
    }
    
    func showLoginPage() {
        dismiss(animated: false)
        delegate?.showLoginPage()
    }
    
    func dismissMenu() {
        dismiss(animated: false)
    }
}

enum MenuList: String, CaseIterable {
    case userProfile = "View user profile"
    case refreshTokens = "Perform action with fresh tokens"
    case refreshAccessToken = "Refresh access token"
    case logout = "Logout"
}
