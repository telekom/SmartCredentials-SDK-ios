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

public class AustriaIDCombinedCardResult: IDCardResult {

    public var sex: String?
    public var nationality: String?
    public var placeOfBirth: String?
    public var principalResidence: String?
    public var height: String?
    public var dateOfIssuance: Date?
    public var eyeColor: String?
    public var dateOfExpiry: Date?
    
    init(with result: MBAustriaCombinedRecognizerResult) {
        super.init()
        
        self.firstName = result.givenName
        self.lastName = result.surname
        self.documentNumber = result.documentNumber
        self.nationality = result.nationality
        self.sex = result.sex
        self.dateOfBirth = result.dateOfBirth?.date
        self.placeOfBirth = result.placeOfBirth
        self.issuer = result.issuingAuthority
        self.principalResidence = result.principalResidence
        self.height = result.height
        self.dateOfIssuance = result.dateOfIssuance?.date
        self.dateOfExpiry = result.dateOfExpiry?.date
        self.eyeColor = result.eyeColour
        self.faceImage = result.faceImage?.image
    }
}
