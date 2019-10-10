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

public class SlovakiaIDCombinedCardResult: IDCardResult {
    
    public var sex: String?
    public var nationality: String?
    public var personalIdentificationNumber: String?
    public var dateOfExpiry: Date?
    public var dateOfIssue: Date?
    public var surnameAtBirth: String?
    public var specialRemarks: String?
    public var placeOfBirth: String?
    public var mrzVerified: Bool?
    
    init(with result: MBSlovakiaCombinedRecognizerResult) {
        super.init()
        
        self.firstName = result.firstName
        self.lastName = result.lastName
        self.documentNumber = result.documentNumber
        self.sex = result.sex
        self.nationality = result.nationality
        self.personalIdentificationNumber = result.personalIdentificationNumber
        self.dateOfBirth = result.dateOfBirth
        self.dateOfExpiry = result.dateOfExpiry
        self.address = result.address
        self.issuer = result.issuingAuthority
        self.dateOfIssue = result.dateOfIssue
        self.surnameAtBirth = result.surnameAtBirth
        self.specialRemarks = result.specialRemarks
        self.placeOfBirth = result.placeOfBirth
        self.mrzVerified = result.mrzVerified
        self.faceImage = result.faceImage?.image
    }
}
