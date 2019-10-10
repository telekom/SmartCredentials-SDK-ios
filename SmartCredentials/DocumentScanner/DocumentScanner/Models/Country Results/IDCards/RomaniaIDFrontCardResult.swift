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

public class RomaniaIDFrontCardResult: IDCardResult {
    
    public var cardNumber: String?
    public var idSeries: String?
    public var cnp: String?
    public var parentNames: String?
    public var nonMRZNationality: String?
    public var placeOfBirth: String?
    public var nonMRZSex: String?
    public var validFrom: Date?
    public var rawValidFrom: String?
    public var validUntil: Date?
    public var rawValidUntil: String?

    init(with result: MBRomaniaIdFrontRecognizerResult) {
        super.init()
        
        self.lastName = result.lastName
        self.firstName = result.firstName
        self.cardNumber = result.cardNumber
        self.idSeries = result.idSeries
        self.cnp = result.cnp
        self.parentNames = result.parentNames
        self.nonMRZNationality = result.nonMRZNationality
        self.placeOfBirth = result.placeOfBirth
        self.address = result.address
        self.issuer = result.issuedBy
        self.nonMRZSex = result.nonMRZSex
        self.validFrom = result.validFrom
        self.rawValidFrom = result.rawValidFrom
        self.validUntil = result.validUntil
        self.rawValidUntil = result.rawValidUntil
        self.faceImage = result.faceImage?.image
    }
}
