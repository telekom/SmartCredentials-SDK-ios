//
//  NavigationBar.swift
//  AuthenticationDemoApp
//
//  Created by Camelia Ignat on 20.01.2023.
//

import UIKit

protocol NavigationBarProtocol: AnyObject {
    func didPressRightButton()
    func didPressLeftButton()
}

extension NavigationBarProtocol {
    func didPressRightButton() {
    }
    
    func didPressLeftButton() {
    }
}

class NavigationBar: UIView {
    @IBOutlet private weak var rightButton: UIButton!
    @IBOutlet private var view: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var leftButton: UIButton!
    
    @IBAction private func didPressRightButton(_ sender: UIButton) {
        delegate?.didPressRightButton()
    }
    
    @IBAction private func didPressOnLeftButton(_ sender: UIButton) {
        delegate?.didPressLeftButton()
    }
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var isRightButtonHidden: Bool {
        set {
            rightButton.isHidden = newValue
        }
        get {
            return rightButton.isHidden
        }
    }
    
    var isLeftButtonHidden: Bool {
        set {
            leftButton.isHidden = newValue
        }
        get {
            return leftButton.isHidden
        }
    }
    
    weak var delegate: NavigationBarProtocol?
    
    override func awakeFromNib() {
        initWithNib()
        rightButton.setTitle("", for: .normal)
    }
    
    private func initWithNib() {
        Bundle.main.loadNibNamed("NavigationBar", owner: self, options: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        setupLayout()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([view.topAnchor.constraint(equalTo: topAnchor),
                                     view.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     view.bottomAnchor.constraint(equalTo: bottomAnchor),
                                     view.trailingAnchor.constraint(equalTo: trailingAnchor),
            ]
        )
    }
}
