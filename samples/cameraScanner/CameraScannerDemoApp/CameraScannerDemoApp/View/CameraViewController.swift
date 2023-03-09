//
//  CameraViewController.swift
//  CameraScannerDemoApp
//
//  Created by Camelia Ignat on 16.11.2022.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    @IBOutlet private weak var scanAgainButton: UIButton!
    @IBOutlet private weak var scannedTextLabel: UILabel!
    @IBOutlet private weak var cameraContentView: UIView!
    @IBOutlet private weak var navigationBar: NavigationBar!
    
    @IBAction private func scanAgainButtonAction(_ sender: UIButton) {
        presenter.capture(type: scannerType ?? .ocr, view: view)
        if scannerType == .ocr {
            navigationBar.isRightButtonHidden = false
        }
    }
    
    var scannerType: ScannerType?
    lazy var presenter = CameraPresenter(with: self)
    private var cameraLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        assert(scannerType != nil, "You must provide a scannerType before trying to show this view controller.")
        setupUI()
        presenter.capture(type: scannerType ?? .ocr, view: view)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        presenter.stopSession(type: scannerType ?? .ocr)
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        setupNavigationBar()
        setupScanAgainButton()
    }
    
    private func setupNavigationBar() {
        navigationBar.title = "Camera Demo"
        navigationBar.isRightButtonHidden = scannerType == .qrCode
        navigationBar.delegate = self
    }
    
    private func setupScanAgainButton() {
        scanAgainButton.layer.cornerRadius = 20
    }
}

extension CameraViewController: NavigationBarProtocol {
    func didPressBackButton() {
        self.dismiss(animated: false)
    }
    
    func didPressRightButton() {
        presenter.startScanningOCR(in: cameraContentView)
    }
}

extension CameraViewController: CameraPresenterView {
    func dismissScreen() {
        self.dismiss(animated: false)
    }
    
    func showCameraLayer(cameraLayer: AVCaptureVideoPreviewLayer) {
        cameraLayer.frame = view.bounds
        cameraLayer.videoGravity = .resizeAspectFill
        self.cameraLayer = cameraLayer
        cameraContentView.layer.addSublayer(self.cameraLayer!)
    }
    
    func showText(_ text: String) {
        navigationBar.isRightButtonHidden = true
        scannedTextLabel.text = text
        cameraLayer?.removeFromSuperlayer()
    }
}
