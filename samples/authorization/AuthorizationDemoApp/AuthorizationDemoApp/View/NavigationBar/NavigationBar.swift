//
//  NavigationBar.swift
//  AuthorizationDemoApp
//
//  Created by Camelia Ignat on 16.11.2022.
//

import Foundation
import UIKit

class NavigationBar: UIView {
    @IBOutlet private var view: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
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
