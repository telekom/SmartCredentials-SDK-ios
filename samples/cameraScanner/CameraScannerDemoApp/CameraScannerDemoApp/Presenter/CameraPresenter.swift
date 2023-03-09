//
//  CameraPresenter.swift
//  CameraScannerDemoApp
//
//  Created by Camelia Ignat on 17.11.2022.
//

import Foundation
import Core
import CameraScanner
import AVFoundation

protocol CameraPresenterView: AnyObject {
    func showCameraLayer(cameraLayer: AVCaptureVideoPreviewLayer)
    func showText(_ text: String)
}

class CameraPresenter {
    weak var view: CameraPresenterView?

    init(with view: CameraPresenterView) {
        self.view = view
    }
    
    private let cameraScanner = SmartCredentialsCameraScannerFactory.smartCredentialsCameraScannerAPI(configuration: SCConfiguration.sharedInstance.current)
    
    func capture(type: ScannerType, view: UIView) {
        switch type {
        case .qrCode:
            cameraScanner.startQRReader(in: view, with: { result in
                switch result{
                case .success(result: let code):
                    self.view?.showText(code)
                case .failure(error: let error):
                    self.view?.showText(error.localizedDescription)
                    print(error)
                }
            })
        case .ocr:
            DispatchQueue.global(qos: .background).async { [weak self] in
                self?.cameraScanner.getOCRCameraPreviewLayer { result in
                    switch result {
                    case .success(result: let previewLayer):
                        DispatchQueue.main.async { [weak self] in
                            self?.view?.showCameraLayer(cameraLayer: previewLayer)
                        }
                    case .failure(error: let error):
                        print(error)
                    }
                }
            }
        }
    }
    
    func stopSession(type: ScannerType) {
        if type == .ocr {
            cameraScanner.stopOCRScanning()
        }
    }
    
    func startScanningOCR(in view: UIView) {
        DispatchQueue.main.async { [weak self] in
            self?.cameraScanner.startOCRScanning(in: view.frame, with: "gs.*-.*", completionHandler: { result in
                switch result {
                case .success(result: let ocrScannerResult):
                    self?.cameraScanner.stopOCRScanning()
                    self?.view?.showText(ocrScannerResult.recognizedText)
                case .failure(error: _):
                    self?.cameraScanner.stopOCRScanning()
                }
            })
        }
    }
}

class SCConfiguration {
    static let sharedInstance = SCConfiguration()
    let current = SmartCredentialsConfiguration(userId: "user")
}
