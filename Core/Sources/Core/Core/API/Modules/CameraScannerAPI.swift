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

import AVFoundation
import UIKit

public typealias QRCodeCompletionHandler = (SmartCredentialsAPIResult<String>) -> ()
public typealias OCRScannerCompletionHandler = (SmartCredentialsAPIResult<OCRScannerResult>) -> ()
public typealias OCRScannerGetPreviewCompletionHandler = (SmartCredentialsAPIResult<AVCaptureVideoPreviewLayer>) -> ()

public protocol CameraScannerAPI {
    
    /// Starts qr barcode scanner in a given container view
    ///
    /// - Parameters:
    ///   - containerView: view in which the barcode scanner will be displayed
    ///   - completionHandler: completion handler with result as parameter (.success with qr coode string or .failure with associated error)
    /// - Returns: void
    func startQRReader(in containerView: UIView, with completionHandler: @escaping QRCodeCompletionHandler)
    
    /// Starts the OCR Camera and returns the preview layer
    ///
    /// - Parameter completionHandler: completion handler with result as parameter (.success with AVCaptureVideoPreviewLayer object or .failure with associated error)
    /// - Returns: void
    func getOCRCameraPreviewLayer(with completionHandler: @escaping OCRScannerGetPreviewCompletionHandler)
    
    /// Starts the OCR Scanner detection
    ///
    /// - Parameters:
    ///   - frame: frame in which OCR Scanner will make the detection
    ///   - regex: regex used for searching the detected text
    ///   - completionHandler: completion handler with result as parameter (.success with detected text or .failure with associated error)
    /// - Returns: void
    func startOCRScanning(in frame: CGRect, completionHandler: @escaping OCRScannerCompletionHandler)
    
    /// Stops the OCR Scanner Camera and detection
    ///
    /// - Returns: void
    func stopOCRScanning()
    
    /// Pauses the OCR Scanner detection
    ///
    /// - Returns: void
    func pauseOCRScanning()
    
    /// Resumes the OCR Scanner detection if it was paused before
    ///
    /// - Returns: void
    func resumeOCRScanning()
}
