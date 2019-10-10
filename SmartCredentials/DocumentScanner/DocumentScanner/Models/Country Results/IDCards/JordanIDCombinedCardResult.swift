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

public class JordanIDCombinedCardResult: IDCardResult {
    
    public var sex: String?
    public var nationalNumber: String?
    public var nationality: String?
    public var dateOfExpiry: Date?
    public var mrzVerified: Bool?
    
    init(with result: MBJordanCombinedRecognizerResult) {
        super.init()
        
        self.firstName = result.name
        self.sex = result.sex
        self.dateOfBirth = result.dateOfBirth
        self.nationalNumber = result.nationalNumber
        self.nationality = result.nationality
        self.issuer = result.issuer
        self.documentNumber = result.documentNumber
        self.dateOfExpiry = result.dateOfExpiry
        self.mrzVerified = result.mrzVerified
        self.faceImage = result.faceImage?.image
    }
}
