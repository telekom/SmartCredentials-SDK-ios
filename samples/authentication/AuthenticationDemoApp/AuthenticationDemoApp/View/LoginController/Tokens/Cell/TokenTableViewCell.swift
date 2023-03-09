//
//  TokenTableViewCell.swift
//  AuthenticationDemoApp
//
//  Created by Camelia Ignat on 19.01.2023.
//

import UIKit

class TokenTableViewCell: UITableViewCell {
    @IBOutlet private weak var tokenTitleLabel: UILabel!
    @IBOutlet private weak var tokenDescriptionLabel: UILabel!
    
    @IBOutlet private weak var expirationDateTitle: UILabel!
    @IBOutlet private weak var expirationDateDescriptionLabel: UILabel!
    
    func setupUI(with token: Token) {
        self.tokenTitleLabel.text = token.name.rawValue
        self.tokenDescriptionLabel.text = token.description
        if token.expirationDate == nil {
            expirationDateTitle.text = ""
            expirationDateTitle.isHidden = true
            expirationDateDescriptionLabel.text = ""
            expirationDateDescriptionLabel.isHidden = true
        } else {
            expirationDateTitle.isHidden = false
            expirationDateTitle.text = "Expiration date"
            expirationDateDescriptionLabel.isHidden = false
            expirationDateDescriptionLabel.text = String(describing: token.expirationDate!)
        }
    }
}
