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

public class MrtdCombinedCardResult: IDCardResult {
    
    public var mrzParsed: Bool?
    public var documentCode: String?
    public var rawDateOfExpiry: String?
    public var dateOfExpiry: Date?
    public var primaryId: String?
    public var secondaryId: String?
    public var rawDateOfBirth: String?
    public var nationality: String?
    public var sex: String?
    public var opt1: String?
    public var opt2: String?
    public var alienNumber: String?
    public var applicationReceiptNumber: String?
    public var immigrantCaseNumber: String?
    public var mrzText: String?
    public var mrzVerified: Bool?
    
    init(with result: MBMrtdCombinedRecognizerResult) {
        super.init()
        
        self.mrzParsed = result.mrzParsed
        self.issuer = result.issuer
        self.documentNumber = result.documentNumber
        self.documentCode = result.documentCode
        self.rawDateOfExpiry = result.rawDateOfExpiry
        self.dateOfExpiry = result.dateOfExpiry
        self.primaryId = result.primaryId
        self.secondaryId = result.secondaryId
        self.rawDateOfBirth = result.rawDateOfBirth
        self.dateOfBirth = result.dateOfBirth
        self.nationality = result.nationality
        self.sex = result.sex
        self.opt1 = result.opt1
        self.opt2 = result.opt2
        self.alienNumber = result.alienNumber
        self.applicationReceiptNumber = result.applicationReceiptNumber
        self.immigrantCaseNumber = result.immigrantCaseNumber
        self.mrzText = result.mrzText
        self.mrzVerified = result.mrzVerified
        self.faceImage = result.faceImage?.image
    }
}
