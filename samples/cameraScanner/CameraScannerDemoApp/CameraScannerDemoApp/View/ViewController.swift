//
//  ViewController.swift
//  CameraScannerDemoApp
//
//  Created by Camelia Ignat on 16.11.2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var navigationBar: NavigationBar!
    
    @IBAction func scanQRCodeTapped(_ sender: UITapGestureRecognizer) {
        presenter.scanQRCodeTapped()
    }
    
    @IBAction func scanOCRTapped(_ sender: UITapGestureRecognizer) {
        presenter.scanOCRTapped()
    }
    
    lazy var presenter = ScannerPresenter(with: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    private func setupUI() {
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationBar.title = "Camera Demo"
        navigationBar.isLeftButtonHidden = true
        navigationBar.isRightButtonHidden = true
    }
}

extension ViewController: ScannerPresenterView {
    func presentAlertController(_ alertController: UIAlertController) {
        self.present(alertController, animated: true)
    }
    
    func presentViewController(_ viewController: UIViewController) {
        self.present(viewController, animated: true)
    }
}

