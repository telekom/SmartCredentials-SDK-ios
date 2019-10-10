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
import Core

class OverlayViewController: MBCustomOverlayViewController {
    
    var scannerDelegate: EIDScannerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.scanningRecognizerRunnerViewControllerDelegate = self
        self.recognizerRunnerViewControllerDelegate = self
        self.metadataDelegates.firstSideFinishedRecognizerRunnerViewControllerDelegate = self
    }
}

/// Protocol for obtaining scanning results
extension OverlayViewController: MBScanningRecognizerRunnerViewControllerDelegate {
    func recognizerRunnerViewController(_ recognizerRunnerViewController: UIViewController & MBRecognizerRunnerViewController, didFinishScanningWith state: MBRecognizerResultState) {
        
        if state == MBRecognizerResultState.valid {
            recognizerRunnerViewController.pauseScanning()
            
            for recognizer in self.recognizerCollection.recognizerList {
                if let result = recognizer.baseResult, result.resultState == .valid {
                    let result = ScannerResultFactory.createScannerResult(for: result)
                    scannerDelegate?.documentScanner(didFind: result)
                }
            }
        }
    }
}

/// Protocol for MBRecognizerRunnerViewController actions
extension OverlayViewController: MBRecognizerRunnerViewControllerDelegate {
    func recognizerRunnerViewControllerUnauthorizedCamera(_ recognizerRunnerViewController: UIViewController & MBRecognizerRunnerViewController) {
        scannerDelegate?.documentScanner(didFind: .openCameraAccessDenied)
    }
    
    func recognizerRunnerViewController(_ recognizerRunnerViewController: UIViewController & MBRecognizerRunnerViewController, didFindError error: Error) {
        // Can be ignored
    }
    
    func recognizerRunnerViewControllerDidClose(_ recognizerRunnerViewController: UIViewController & MBRecognizerRunnerViewController) {
        scannerDelegate?.documentScannerDidClose()
    }
    
    func recognizerRunnerViewControllerWillPresentHelp(_ recognizerRunnerViewController: UIViewController & MBRecognizerRunnerViewController) {
        // Can be ignored
    }
    
    func recognizerRunnerViewControllerDidResumeScanning(_ recognizerRunnerViewController: UIViewController & MBRecognizerRunnerViewController) {
    }
    
    func recognizerRunnerViewControllerDidStopScanning(_ recognizerRunnerViewController: UIViewController & MBRecognizerRunnerViewController) {
    }
}

/**
 * Called when scanning library finishes performing recognition of the first side of the document.
 * NOTE: This method is called on background processing thread. Make sure that you dispatch all your UI API calls to main thread.
 */
extension OverlayViewController: MBFirstSideFinishedRecognizerRunnerViewControllerDelegate {
    func recognizerRunnerViewControllerDidFinishRecognition(ofFirstSide recognizerRunnerViewController: UIViewController & MBRecognizerRunnerViewController) {
        scannerDelegate?.documentScannerDidFinishRecognitionFirstSide()
    }
}
