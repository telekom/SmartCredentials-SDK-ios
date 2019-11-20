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

class DefaultEIDScanner {
    
    let logger = LoggerProvider.sharedInstance.logger
    var configuration: SmartCredentialsConfiguration
    
    var microblinkScanner: MicroblinkScanner?
    var license: String
    var licensee: String
    
    // MARK: - Initializers
    init(configuration: SmartCredentialsConfiguration, license: String, licensee: String) {
        self.configuration = configuration
        self.license = license
        self.licensee = licensee
    }
    
    // MARK: - Jailbreak Check
    private func isJailbroken() -> Bool {
        if configuration.jailbreakCheckEnabled {
            return JailbreakDetection.isJailbroken()
        }
        return false
    }
}

extension DefaultEIDScanner: DocumentScannerAPI {
    func startDocumentScanning(scannerRecognizer: ScannerRecognizer, cameraSettings: EIDCameraSettings, scannerDelegate: EIDScannerDelegate) {
        guard isJailbroken() == false else {
            logger?.log(.error, message: Constants.Logger.jailbreakError, className: className)
            scannerDelegate.documentScanner(didFind: .jailbreakDetected)
            return
        }
        
        microblinkScanner = MicroblinkScanner(scannerRecognizer: scannerRecognizer,
                                       cameraSettings: cameraSettings,
                                       license: license,
                                       licensee: licensee,
                                       scannerDelegate: scannerDelegate)
        
        microblinkScanner?.startDocumentScanning()
    }

    func pauseDocumentScanning() {
        microblinkScanner?.pauseDocumentScanning()
    }
    
    func resumeDocumentScanning() {
        microblinkScanner?.resumeDocumentScanning()
    }
}

extension DefaultEIDScanner: Nameable {
}
