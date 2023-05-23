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

import Core

class DefaultOCRScanner {

    var ocrScanner: OCRScanner?

    func getOCRCameraPreviewLayer(with completionHandler: @escaping OCRScannerGetPreviewCompletionHandler) {
        ocrScanner = OCRScanner()
        ocrScanner?.getPreviewLayer(with: { result in
            switch result {
            case .success(let previewLayer):
                self.ocrScanner?.startSession()
                completionHandler(.success(result: previewLayer))
            case .failure(let error):
                completionHandler(.failure(error: error))
            @unknown default:
                // Any future cases not recognized by the compiler yet
                break
            }
        })
    }
    
    func startOCRScanning(in frame: CGRect, completionHandler: @escaping OCRScannerCompletionHandler) {
        ocrScanner?.startScanning(in: frame, completionHandler: completionHandler)
    }
    
    func pauseOCRScanning() {
        ocrScanner?.stopScanning()
    }
    
    func resumeOCRScanning() {
        ocrScanner?.resumeScanning()
    }
    
    func stopOCRScanning() {
        ocrScanner?.stopSession()
    }
}
