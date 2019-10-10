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

import Foundation
import Core

class CameraScannerController {
    
    let logger = LoggerProvider.sharedInstance.logger
    var configuration: SmartCredentialsConfiguration
    
    var qrReader: DefaultQRCodeReader?
    var ocrScanner: DefaultOCRScanner?
    
    // MARK: - Initializers
    init(configuration: SmartCredentialsConfiguration) {
        self.configuration = configuration
    }
    
    // MARK: - Jailbreak Check
    private func isJailbroken() -> Bool {
        if configuration.jailbreakCheckEnabled {
            return JailbreakDetection.isJailbroken()
        }
        return false
    }
}

// MARK: - Camera Scanner API
extension CameraScannerController: CameraScannerAPI {
    // MARK: - QR Reader
    func startQRReader(in containerView: UIView, with completionHandler: @escaping QRCodeCompletionHandler) {
        guard isJailbroken() == false else {
            logger?.log(.error, message: Constants.Logger.jailbreakError, className: className)
            completionHandler(.failure(error: .jailbreakDetected))
            return
        }
        
        qrReader = DefaultQRCodeReader()
        qrReader?.startQRReader(in: containerView, with: completionHandler)
    }
    
    // MARK: - OCR
    func getOCRCameraPreviewLayer(with completionHandler: @escaping OCRScannerGetPreviewCompletionHandler) {
        guard isJailbroken() == false else {
            logger?.log(.error, message: Constants.Logger.jailbreakError, className: className)
            completionHandler(.failure(error: .jailbreakDetected))
            return
        }
        
        ocrScanner = DefaultOCRScanner()
        ocrScanner?.getOCRCameraPreviewLayer(with: completionHandler)
    }
    
    func startOCRScanning(in frame: CGRect, with regex: String?, completionHandler: @escaping OCRScannerCompletionHandler) {
        guard isJailbroken() == false else {
            logger?.log(.error, message: Constants.Logger.jailbreakError, className: className)
            completionHandler(.failure(error: .jailbreakDetected))
            return
        }
        
        ocrScanner?.startOCRScanning(in: frame, with: regex, completionHandler: completionHandler)
    }
    
    func stopOCRScanning() {
        ocrScanner?.stopOCRScanning()
    }
    
    func pauseOCRScanning() {
        ocrScanner?.pauseOCRScanning()
    }
    
    func resumeOCRScanning() {
        ocrScanner?.resumeOCRScanning()
    }
}

extension CameraScannerController: Nameable {
}
