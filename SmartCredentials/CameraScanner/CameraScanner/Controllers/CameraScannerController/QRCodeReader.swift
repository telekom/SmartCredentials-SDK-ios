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
import Core

protocol QRCodeReaderProtocol: AnyObject {
    func qrCodeReader(_ qrCodeReader: QRCodeReader, didFind qrCode: String)
}

class QRCodeReader: NSObject {
    
    let logger = LoggerProvider.sharedInstance.logger
    
    // Video Capture
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    // UI Elements
    var whiteView: UIView?
    var qrCodeFrameView: UIView?
    var qrCodeLabel = UILabel()
    var detectionFrame: CGRect {
        let width = (videoContainerView.frame.width - (Constants.QRCodeReader.qrScannerPadding * 2))
        let height = width
        return CGRect(x: (videoContainerView?.center.x)! - width / 2,
                      y: (videoContainerView?.center.y)! - height / 2,
                      width: width,
                      height: height)
    }
    
    //@Injected
    var videoContainerView: UIView!
    weak var delegate: QRCodeReaderProtocol!
    
    
    // MARK: - Start
    init(videoContainerView: UIView, delegate: QRCodeReaderProtocol) {
        self.videoContainerView = videoContainerView
        self.delegate = delegate
    }
    
    func start() {
        initializeQRCodeReader()
        captureSession.startRunning()
    }
    
    func stop() {
        captureSession.stopRunning()
        
        qrCodeFrameView?.removeFromSuperview()
        qrCodeLabel.removeFromSuperview()
        videoPreviewLayer?.removeFromSuperlayer()
        whiteView?.removeFromSuperview()
    }
    
    // MARK: - Initializations
    private func initializeQRCodeReader() {
        initializeCaptureSession()
        initializeCaptureMetadataOutput()
        initializeVideoPreviewLayer()
        initializeUIElements()
    }
    
    // MARK: - Private initializers
    private func initializeCaptureSession() {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            logger?.log(.error, message: Constants.Logger.createCaptureDeviceForMediaError, className: className)
            return
        }
        
        let deviceInput: AVCaptureDeviceInput
        do {
            deviceInput = try AVCaptureDeviceInput(device: captureDevice)
        } catch {
            logger?.log(.error, message: Constants.Logger.createCaptureDeviceInputError, className: className)
            return
        }
        
        if captureSession.canAddInput(deviceInput) {
            captureSession.addInput(deviceInput)
        } else {
            logger?.log(.error, message: Constants.Logger.addVideoInputCaptureSessionError, className: className)
        }
    }
    
    private func initializeCaptureMetadataOutput() {
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            logger?.log(.error, message: Constants.Logger.addMetadataOutputError, className: className)

            return
        }
    }
    
    private func initializeVideoPreviewLayer() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        guard let videoPreviewLayer = videoPreviewLayer else {
            logger?.log(.error, message: Constants.Logger.createVideoPreviewLayerError, className: className)
            return
        }
        
        whiteView = UIView(frame: videoContainerView.bounds)
        let maskLayer = CAShapeLayer()
        let viewPath = UIBezierPath(rect: videoContainerView.bounds)
        let squarePath = UIBezierPath(rect: detectionFrame)
        
        viewPath.append(squarePath)
        
        maskLayer.path = viewPath.cgPath
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        
        whiteView?.layer.mask = maskLayer
        whiteView?.clipsToBounds = true
        whiteView?.alpha = 0.8
        whiteView?.backgroundColor = .gray
        
        videoPreviewLayer.frame = videoContainerView.layer.bounds
        videoPreviewLayer.videoGravity = .resizeAspectFill
        
        videoContainerView.layer.addSublayer(videoPreviewLayer)
        videoContainerView.addSubview(whiteView!)
    }
    
    //TODO: rename this method
    private func initializeUIElements() {
        // QRCode frame
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.green.cgColor
        qrCodeFrameView?.layer.borderWidth = 2
        
        // QRCode Label
        qrCodeLabel.frame = CGRect(x: 0,
                                   y: videoContainerView.frame.size.height - 40,
                                   width: videoContainerView.frame.size.width,
                                   height: Constants.QRCodeReader.qrLabelHeight)
        qrCodeLabel.textAlignment = .center
        qrCodeLabel.backgroundColor = .gray
        videoContainerView.addSubview(qrCodeLabel)
        
        // Container View
        videoContainerView.addSubview(qrCodeFrameView!)
        videoContainerView.bringSubviewToFront(qrCodeFrameView!)
    }
}

extension QRCodeReader: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = .zero
            qrCodeLabel.text = ""
            return
        }
        
        guard let metadataObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject else {
            return
        }
        
        if metadataObj.type == .qr {
            guard let barcodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj) else {
                return
            }
            
            if detectionFrame.contains(barcodeObject.bounds) {
                if let qrCodeString = metadataObj.stringValue {
                    qrCodeFrameView?.frame = barcodeObject.bounds
                    qrCodeLabel.text = qrCodeString
                    
                    delegate.qrCodeReader(self, didFind: qrCodeString)
                }
            } else {
                qrCodeFrameView?.frame = .zero
                qrCodeLabel.text = ""
            }
        }
    }
}
