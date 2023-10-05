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
import UIKit

enum Constants {
    
    enum Item {
        static let id = "123"
        static let actionId = "12"
    }
    
    enum Channel {
        static let type1DRawValue = "type1D"
        static let type2DRawValue = "type2D"
        static let typeUnknownRawValue = "typeUnknown"
    }
    
    enum ItemType {
        static let voucherRawValue = 0
        static let tokenRawValue = 1
        static let otherRawValue = 2
        static let totpRawValue = 3
        static let hotpRawValue = 4
        
        static let voucher = "voucher"
        static let token = "token"
        static let other = "other"
        static let totp = "totp"
        static let hotp = "hotp"
        static let incorrectStringType = "incorrect_string_type"
    }
    
    enum ContentType {
        static let sensitiveRawValue = 0
        static let nonSensitiveRawValue = 1
    }
    
    enum ItemPrivateData {
        static let key = "key"
        static let value = "value"
    }
    
    enum Configuration {
        static let userId = "1"
    }
    
    enum OTP {
        static let code = "abc"
        static let remainingSeconds = 1
        static let counter = 1
    }
    
    enum CameraScanner {
        static let text = "abc"
        static let image = UIImage.testImage()
    }
}
