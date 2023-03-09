//
//  ScannerPresenter.swift
//  CameraScannerDemoApp
//
//  Created by Camelia Ignat on 17.11.2022.
//

import Foundation
import UIKit
import AVFoundation

protocol ScannerPresenterView: AnyObject {
    func presentViewController(_ viewController: UIViewController)
    func presentAlertController(_ alertController: UIAlertController)
}

class ScannerPresenter {
    weak var view: ScannerPresenterView?

    init(with view: ScannerPresenterView) {
        self.view = view
    }
    
    func scanQRCodeTapped() {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            presentCameraScanner(with: .qrCode)
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                DispatchQueue.main.async { [weak self] in
                    if granted {
                        self?.presentCameraScanner(with: .qrCode)
                    } else {
                        self?.showCameraPermissionPopup()
                    }
                }
            })
        }
    }
    
    func scanOCRTapped() {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            presentCameraScanner(with: .ocr)
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                DispatchQueue.main.async { [weak self] in
                    if granted {
                        self?.presentCameraScanner(with: .ocr)
                    } else {
                        self?.showCameraPermissionPopup()
                    }
                }
            })
        }
    }
    
    private func presentCameraScanner(with type: ScannerType) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CameraViewController") as? CameraViewController
        vc?.scannerType = type
        vc?.modalPresentationStyle = .overFullScreen
        view?.presentViewController(vc ?? UIViewController())
    }
    
    private func showCameraPermissionPopup() {
        let alertController = UIAlertController(title: "Camera Permission Required", message: "Please enable camera permissions in settings.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
                //Redirect to Settings app
                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(cancelAction)
            
            alertController.addAction(okAction)
            
            view?.presentAlertController(alertController)
    }
}
