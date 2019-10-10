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

public class PolandIDCombinedCardResult: IDCardResult {

    public var familyName: String?
    public var parentsGivenNames: String?
    public var sex: String?
    public var nationality: String?
    public var dateOfExpiry: Date?
    public var mrzVerified: Bool?
    
    init(with result: MBPolandCombinedRecognizerResult) {
        super.init()
        
        self.firstName = result.givenNames
        self.lastName = result.surname
        self.familyName = result.familyName
        self.parentsGivenNames = result.parentsGivenNames
        self.sex = result.sex
        self.nationality = result.nationality
        self.issuer = result.issuer
        self.documentNumber = result.documentNumber
        self.personalNumber = result.personalNumber
        self.dateOfBirth = result.dateOfBirth
        self.dateOfExpiry = result.dateOfExpiry
        self.mrzVerified = result.mrzVerified
        self.faceImage = result.faceImage?.image
    }
}
