/*
* Copyright (c) 2019 Telekom Deutschland AG
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import MicroBlink

#if canImport(Core)
import Core
#endif

class MicroblinkScanner {
    
    private var recognizerRunnerViewController: MBRecognizerRunnerViewController!
    
    var scannerRecognizer: ScannerRecognizer
    var cameraSettings: EIDCameraSettings
    var scannerDelegate: EIDScannerDelegate
    
    init(scannerRecognizer: ScannerRecognizer, cameraSettings: EIDCameraSettings, license: String, licensee: String, scannerDelegate: EIDScannerDelegate) {
        self.scannerRecognizer = scannerRecognizer
        self.cameraSettings = cameraSettings
        self.scannerDelegate = scannerDelegate

        
        MBMicroblinkSDK.sharedInstance().setLicenseKey(license, andLicensee: licensee)
    }
    
    func checkCameraPermissions() {
        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
            initializeRecognizerViewController()
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    self.initializeRecognizerViewController()
                } else {
                    self.scannerDelegate.documentScanner(didFind: .openCameraAccessDenied)
                }
            })
        }
    }
    
    func initializeRecognizerViewController() {
        let recognizerList = [scannerRecognizer.recognizerSettings()]
        let recognizerCollection : MBRecognizerCollection = MBRecognizerCollection(recognizers: recognizerList)
        
        let mbCameraSettings: MBCameraSettings = MBCameraSettings.init()
        mbCameraSettings.cameraPreset = cameraSettings.cameraPreset.mbCameraPreset()
        mbCameraSettings.cameraType = cameraSettings.cameraType.mbCameraType()
        
        let overlayViewController: OverlayViewController = OverlayViewController(recognizerCollection: recognizerCollection, cameraSettings: mbCameraSettings)
        overlayViewController.scanningRegion = cameraSettings.scanningRegion
        overlayViewController.showStatusBar = cameraSettings.showStatusBar
        overlayViewController.scannerDelegate = scannerDelegate
        
        overlayViewController.reconfigureRecognizers(recognizerCollection)
        
        recognizerRunnerViewController = MBViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: overlayViewController)
        
        scannerDelegate.documentScanner(didStartIn: recognizerRunnerViewController as! UIViewController)
    }
}

extension MicroblinkScanner {
    func startDocumentScanning() {
        checkCameraPermissions()
    }
    
    func pauseDocumentScanning() {
        if !recognizerRunnerViewController.isScanningPaused() {
            recognizerRunnerViewController.pauseScanning()
        }
    }
    
    func resumeDocumentScanning() {
        if recognizerRunnerViewController.isScanningPaused() {
            recognizerRunnerViewController.resumeScanningAndResetState(false)
        }
    }
}

