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
import TesseractOCR

#if canImport(Core)
import Core
#endif

enum OCRScannerStatus {
    case started
    case paused
    case stopped
}

class OCRScanner: NSObject {
    
    var logger = LoggerProvider.sharedInstance.logger
    
    // Video Capture
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var scannerStatus: OCRScannerStatus = .stopped

    var regex: String?
    var detectionFrame: CGRect = .zero
    var completionHandler: OCRScannerCompletionHandler?
    var getPreviewCompletionHandler: OCRScannerGetPreviewCompletionHandler?
    var counter = 0
    
    // MARK: - Initializations
    override init() {
    }

    func checkCameraPermissions() {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            initializeCaptureSession()
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    self.initializeCaptureSession()
                } else {
                    self.logger?.log(.error, message: Constants.CameraScannerLogger.cameraAccess, className: self.className)
                    self.getPreviewCompletionHandler?(.failure(error: .openCameraAccessDenied))
                }
            })
        }
    }
    
    func initializeCaptureSession() {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            logger?.log(.error, message: Constants.CameraScannerLogger.createCaptureDeviceForMediaError, className: className)
            getPreviewCompletionHandler?(.failure(error: .createCaptureDeviceError))
            return
        }
        
        let deviceInput: AVCaptureDeviceInput
        do {
            deviceInput = try AVCaptureDeviceInput(device: captureDevice)
        } catch {
            logger?.log(.error, message: Constants.CameraScannerLogger.createCaptureDeviceInputError, className: className)
            getPreviewCompletionHandler?(.failure(error: .createCaptureDeviceInputError))
            return
        }
        
        if captureSession.canAddInput(deviceInput) {
            captureSession.addInput(deviceInput)
        } else {
            logger?.log(.error, message: Constants.CameraScannerLogger.addVideoInputCaptureSessionError, className: className)
            getPreviewCompletionHandler?(.failure(error: .addDeviceInputError))
            return
        }
        
        initializeVideoDataOutput()
    }
    
    func initializeVideoDataOutput() {
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as String): NSNumber(value:kCVPixelFormatType_32BGRA)]
        
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
            
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        } else {
            logger?.log(.error, message: Constants.CameraScannerLogger.addVideoDataOutputError, className: className)
            getPreviewCompletionHandler?(.failure(error: .addVideoDataOutputError))
            return
        }
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        getPreviewCompletionHandler?(.success(result: videoPreviewLayer!))
    }
    
    func getPreviewLayer(with completionHandler: @escaping OCRScannerGetPreviewCompletionHandler) {
        getPreviewCompletionHandler = completionHandler
        checkCameraPermissions()
    }
    
    func startSession() {
        captureSession.startRunning()
    }
    
    func stopSession() {
        stopScanning()
        captureSession.stopRunning()
    }

    func startScanning(in frame: CGRect, regex: String?, completionHandler: @escaping OCRScannerCompletionHandler) {
        self.regex = regex
        self.detectionFrame = frame
        self.completionHandler = completionHandler
        
        if scannerStatus != .paused {
            scannerStatus = .started
        }
    }

    func stopScanning() {
        scannerStatus = .stopped
    }
    
    func resumeScanning() {
        if scannerStatus == .stopped {
            scannerStatus = .started
        }
    }
    
    // MARK: - Image Recognition
    func performImageRecognition(_ image: UIImage) {
        scannerStatus = .paused
        counter += 1

        if let tesseract = G8Tesseract(language: Constants.OCRScanner.tesseractLanguageName) {
            tesseract.engineMode = .tesseractOnly
            tesseract.pageSegmentationMode = .auto
            tesseract.image = image.blackAndWhite()
            
            if let videoPreviewLayer = videoPreviewLayer, detectionFrame != .zero  {
                let ratio = tesseract.image.size.width / videoPreviewLayer.frame.size.width
                let convertedFrame = CGRect(x: detectionFrame.origin.x * ratio,
                                            y: detectionFrame.origin.y * ratio,
                                            width: detectionFrame.size.width * ratio,
                                            height: detectionFrame.size.height * ratio)
                tesseract.rect = convertedFrame
            }
            
            tesseract.recognize()

            scannerStatus = .started
     
            if regex != nil {
                let found = tesseract.recognizedText.matches(for: regex!)
                if found.count > 0 {
                    var originalImage = image
                    if let cgImage = image.cgImage {
                        originalImage = UIImage(cgImage: cgImage, scale: 1, orientation: .right)
                    }
                    
                    let ocrScannerResult = OCRScannerResult(recognizedText: found.first!, lastImage: originalImage)
                    completionHandler?(.success(result: ocrScannerResult))
                } else if counter > 20 {
                    completionHandler?(.failure(error: .formatNotFoundError))
                }
            } else {
                var originalImage = image
                if let cgImage = image.cgImage {
                    originalImage = UIImage(cgImage: cgImage, scale: 1, orientation: .right)
                }
                
                let ocrScannerResult = OCRScannerResult(recognizedText: tesseract.recognizedText, lastImage: originalImage)
                completionHandler?(.success(result: ocrScannerResult))
            }
        } else {
            completionHandler?(.failure(error: .initTesseractError))
        }
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
extension OCRScanner: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard scannerStatus == .started else {
            return
        }
        
        guard let image = UIImage(from: sampleBuffer) else {
            return
        }
        
        performImageRecognition(image)
    }
}
