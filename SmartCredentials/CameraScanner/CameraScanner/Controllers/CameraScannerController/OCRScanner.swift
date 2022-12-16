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
import Core
import Vision

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
    
    private var lastImage = UIImage()
    
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
                    self.logger?.log(.error, message: Constants.Logger.cameraAccess, className: self.className)
                    self.getPreviewCompletionHandler?(.failure(error: .openCameraAccessDenied))
                }
            })
        }
    }
    
    func initializeCaptureSession() {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            logger?.log(.error, message: Constants.Logger.createCaptureDeviceForMediaError, className: className)
            getPreviewCompletionHandler?(.failure(error: .createCaptureDeviceError))
            return
        }
        
        let deviceInput: AVCaptureDeviceInput
        do {
            deviceInput = try AVCaptureDeviceInput(device: captureDevice)
        } catch {
            logger?.log(.error, message: Constants.Logger.createCaptureDeviceInputError, className: className)
            getPreviewCompletionHandler?(.failure(error: .createCaptureDeviceInputError))
            return
        }
        
        if captureSession.canAddInput(deviceInput) {
            captureSession.addInput(deviceInput)
        } else {
            logger?.log(.error, message: Constants.Logger.addVideoInputCaptureSessionError, className: className)
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
            logger?.log(.error, message: Constants.Logger.addVideoDataOutputError, className: className)
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

        lastImage = image
        // Get the CGImage on which to perform requests.
        guard let cgImage = image.cgImage else { return }

        // Create a new image-request handler.
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)

        // Create a new request to recognize text.
        if #available(iOS 13.0, *) {
            let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
            
            do {
                // Perform the text-recognition request.
                try requestHandler.perform([request])
            } catch {
                completionHandler?(.failure(error: .formatNotFoundError))
            }
        } else {
            // Minimum iOS version needed is 13.0
        }
    }
    
    func recognizeTextHandler(request: VNRequest, error: Error?) {
        if #available(iOS 13.0, *) {
            guard let observations =
                    request.results as? [VNRecognizedTextObservation] else {
                return
            }
            
            let recognizedStrings = observations.compactMap { observation in
                // Return the string of the top VNRecognizedText instance.
                return observation.topCandidates(1).first?.string
            }
            
            // Process the recognized strings.
            let ocrScannerResult = OCRScannerResult(recognizedText: recognizedStrings.joined(separator: " "), lastImage: lastImage)
            completionHandler?(.success(result: ocrScannerResult))
        } else {
            // Minimum iOS version needed is 13.0
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
