//
//  NavigationBar.swift
//  CameraScannerDemoApp
//
//  Created by Camelia Ignat on 16.11.2022.
//

import Foundation
import UIKit

protocol NavigationBarProtocol: AnyObject {
    func didPressBackButton()
    func didPressRightButton()
}

extension NavigationBarProtocol {
    func didPressBackButton() {
    }
    
    func didPressRightButton() {
    }
}

class NavigationBar: UIView {
    @IBOutlet private var view: UIView!
    @IBOutlet private weak var leftButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var rightButton: UIButton!
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
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
    
    var isRightButtonHidden: Bool {
        set {
            rightButton.isHidden = newValue
        }
        get {
            return rightButton.isHidden
        }
    }
        
    weak var delegate: NavigationBarProtocol?
    
    @IBAction private func backButtonAction(_ sender: UIButton) {
        delegate?.didPressBackButton()
    }
    
    @IBAction func rightButtonAction(_ sender: UIButton) {
        delegate?.didPressRightButton()
    }
    
    override func awakeFromNib() {
        initWithNib()
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
