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
import Storage
import CameraScanner

class OTPController {

    var storage: StorageAPI
    var cameraScanner: CameraScannerAPI
    
    let logger = LoggerProvider.sharedInstance.logger
    var configuration: SmartCredentialsConfiguration
    
    var totpGenerators: [DefaultOTPGenerator] = []

    // MARK: - Initializers
    init(configuration: SmartCredentialsConfiguration, storage: StorageAPI, cameraScanner: CameraScannerAPI) {
        self.configuration = configuration
        self.storage = storage
        self.cameraScanner = cameraScanner
    }
    
    // MARK: - Jailbreak Check
    private func isJailbroken() -> Bool {
        if configuration.jailbreakCheckEnabled {
            return JailbreakDetection.isJailbroken()
        }
        return false
    }
}

// MARK: - OTP API
extension OTPController: OTPAPI {
    func addOTPItemAccount(_ item: ItemEnvelope) -> SmartCredentialsAPIEmptyResult {
        guard isJailbroken() == false else {
            logger?.log(.error, message: Constants.Logger.jailbreakError, className: className)
            return .failure(error: .jailbreakDetected)
        }
        
        return storage.put(item, with: ItemContextFactory.itemContext())
    }
    
    func importOTPItemViaQR(in containerView: UIView, for itemId: String, completionHandler: @escaping ImportOTPItemCompletionHandler) {
        guard isJailbroken() == false else {
            logger?.log(.error, message: Constants.Logger.jailbreakError, className: className)
            completionHandler(.failure(error: .jailbreakDetected))
            return
        }
        
        cameraScanner.startQRReader(in: containerView) { qrReaderResult in
            let otpItemBuilder = DefaultOTPItemBuilder()
            let otpBuilderResult = otpItemBuilder.otpItem(from: qrReaderResult, itemId: itemId)
            
            switch otpBuilderResult {
            case .success(let item, let otpResult):
                
                let addOTPResult = self.addOTPItemAccount(item)
                switch addOTPResult {
                case .success:
                    completionHandler(.success(result: otpResult))
                case .failure(let error):
                    completionHandler(.failure(error: error))
                }
                
            case .failure(let error):
                completionHandler(.failure(error: error))
            }
        }
    }
    
    func getHOTPCode(for itemFilter: ItemFilter) -> SmartCredentialsAPIResult<String> {
        guard isJailbroken() == false else {
            logger?.log(.error, message: Constants.Logger.jailbreakError, className: className)
            return .failure(error: .jailbreakDetected)
        }
        
        let getItemDetailsResult = storage.getItemDetails(for: itemFilter)
        
        switch getItemDetailsResult {
        case .success(var itemEnvelope):
            let otpGenerator = DefaultOTPGenerator(itemEnvelope: itemEnvelope)
            let otpCodeResult = otpGenerator.getHOTPCode()
            
            switch otpCodeResult {
            case .success(let otpCode):
                if let counter = otpCode.counter {
                    itemEnvelope.identifier[OTPKeys.counter] = counter
                    let itemContext = ItemContextFactory.itemContext()
                    _ = storage.update(itemEnvelope, with: itemContext)
                }
                
                return .success(result: otpCode.code)
                
            case .failure(let error):
                return .failure(error: error)
            }
            
        case .failure(let error):
            return .failure(error: error)
        }
    }
    
    func startTOTPGenereration(for itemFilter: ItemFilter, completionHandler: @escaping GETOTPCompletionHandler) {
        guard isJailbroken() == false else {
            logger?.log(.error, message: Constants.Logger.jailbreakError, className: className)
            completionHandler(.failure(error: .jailbreakDetected))
            return
        }
        
        let getItemDetailsResult = storage.getItemDetails(for: itemFilter)

        switch getItemDetailsResult {
        case .success(let itemEnvelope):
            let otpGenerator = DefaultOTPGenerator(itemEnvelope: itemEnvelope)
            totpGenerators.append(otpGenerator)

            otpGenerator.startTOTPGeneration(completionHandler: completionHandler)
            
        case .failure(let error):
            completionHandler(.failure(error: error))
        }
    }
    
    func stopTOTPGeneration(for itemFilter: ItemFilter) -> SmartCredentialsAPIEmptyResult {
        guard isJailbroken() == false else {
            logger?.log(.error, message: Constants.Logger.jailbreakError, className: className)
            return .failure(error: .jailbreakDetected)
        }
        
        let getItemDetailsResult = storage.getItemDetails(for: itemFilter)

        switch getItemDetailsResult {
        case .success(let itemEnvelope):
            var otpGenerator: DefaultOTPGenerator?
            var foundIndex: Int?
            for (index, generator) in totpGenerators.enumerated() {
                if generator.itemEnvelope.itemId == itemEnvelope.itemId {
                    otpGenerator = generator
                    foundIndex = index
                    break
                }
            }
            
            if let otpGenerator = otpGenerator,
                let foundIndex = foundIndex {
                totpGenerators.remove(at: foundIndex)
                return otpGenerator.stopTOTPGeneration()
            } else {
                return .failure(error: .noTOTPRunning)
            }
            
        case .failure(let error):
            return .failure(error: error)
        }
    }
    
}

extension OTPController: Nameable {
}
