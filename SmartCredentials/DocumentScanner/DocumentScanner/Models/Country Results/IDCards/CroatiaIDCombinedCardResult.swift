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

public class CroatiaIDCombinedCardResult: IDCardResult {

    public var sex: String?
    public var citizenship: String?
    public var dateOfExpiry: Date?
    public var dateOfExpiryPermanent: Bool = false
    public var dateOfIssue: Date?
    public var nonResident: Bool = false
    public var documentBilingual: Bool = false
    public var mrzVerified: Bool = false
    
    init(with result: MBCroatiaCombinedRecognizerResult) {
        super.init()
        
        self.firstName = result.firstName
        self.lastName = result.lastName
        self.documentNumber = result.identityCardNumber
        self.sex = result.sex
        self.citizenship = result.citizenship
        self.dateOfBirth = result.dateOfBirth
        self.dateOfExpiry = result.dateOfExpiry
        self.dateOfExpiryPermanent = result.dateOfExpiryPermanent
        self.address = result.address
        self.issuer = result.issuingAuthority
        self.dateOfIssue = result.dateOfIssue
        self.personalNumber = result.personalIdentificationNumber
        self.nonResident = result.nonResident
        self.documentBilingual = result.documentBilingual
        self.mrzVerified = result.mrzVerified
        self.faceImage = result.faceImage?.image
    }
}
