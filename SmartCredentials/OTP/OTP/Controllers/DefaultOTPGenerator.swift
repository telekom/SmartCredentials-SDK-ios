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

#if canImport(Core)
import Core
#endif

class DefaultOTPGenerator {
    
    var totpCompletionHandler: GETOTPCompletionHandler?
    var totp: TOTP?
    var refreshTOTPTimer: Timer?
    
    var itemEnvelope: ItemEnvelope
    
    init(itemEnvelope: ItemEnvelope) {
        self.itemEnvelope = itemEnvelope
    }
    
    func getHOTPCode() -> SmartCredentialsAPIResult<OTPCode> {
        guard let hotp = HOTP(dictionary: itemEnvelope.identifier) else {
            return .failure(error: .invalidItemForOTP)
        }
        
        return .success(result: hotp.otpCode())
    }
    
    func startTOTPGeneration(completionHandler: @escaping GETOTPCompletionHandler) {
        guard let totp = TOTP(dictionary: itemEnvelope.identifier) else {
            completionHandler(.failure(error: .invalidItemForOTP))
            return
        }
        
        self.totp = totp
        self.totpCompletionHandler = completionHandler
        
        let firstTOTPCode = totp.otpCode()
        completionHandler(.success(result: firstTOTPCode))
        
        if let remainingSeconds = firstTOTPCode.remainingSeconds {
            refreshTOTPTimer = Timer.scheduledTimer(timeInterval: TimeInterval(remainingSeconds), target: self, selector: #selector(self.configureTOTPTimer), userInfo: nil, repeats: false)
        }
    }
    
    func stopTOTPGeneration() -> SmartCredentialsAPIEmptyResult {
        totpCompletionHandler = nil
        totp = nil
        refreshTOTPTimer?.invalidate()
        
        return .success
    }
    
    @objc private func configureTOTPTimer() {
        refreshTOTPTimer?.invalidate()
        
        if let totpCode = totp?.otpCode() {
            totpCompletionHandler?(.success(result: totpCode))
            refreshTOTPTimer = Timer.scheduledTimer(timeInterval: TimeInterval(totpCode.remainingSeconds!), target: self, selector: #selector(self.refreshTOTPCode), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func refreshTOTPCode() {
        if let totpCode = totp?.otpCode() {
            totpCompletionHandler?(.success(result: totpCode))
        }
    }
}
