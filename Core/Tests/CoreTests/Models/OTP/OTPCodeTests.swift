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

import XCTest
@testable import Core

class OTPCodeTests: XCTestCase {

    func testCreateTOTPCode() {
        let totpCode = OTPCode(totpCode: Constants.OTP.code,
                               remainingSeconds: Constants.OTP.remainingSeconds)
        
        XCTAssertEqual(totpCode.code, Constants.OTP.code)
        XCTAssertEqual(totpCode.remainingSeconds, Constants.OTP.remainingSeconds)
        XCTAssertEqual(totpCode.type, .TOTP)
    }
    
    func testCreateHOTPCode() {
        let hotpCode = OTPCode(hotpCode: Constants.OTP.code,
                               counter: Constants.OTP.counter)
        
        XCTAssertEqual(hotpCode.code, Constants.OTP.code)
        XCTAssertEqual(hotpCode.counter, Constants.OTP.counter)
        XCTAssertEqual(hotpCode.type, .HOTP)
    }
}
