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

public class SerbiaIDCombinedCardResult: IDCardResult {
    
    public var identityCardNumber: String?
    public var dateOfExpiry: Date?
    public var dateOfIssue: Date?
    public var jmbg: String?
    public var nationality: String?
    public var sex: String?
    public var mrzVerified: Bool?
    
    init(with result: MBSerbiaCombinedRecognizerResult) {
        super.init()
        
        self.identityCardNumber = result.identityCardNumber
        self.dateOfExpiry = result.dateOfExpiry
        self.dateOfIssue = result.dateOfIssue
        self.jmbg = result.jmbg
        self.firstName = result.firstName
        self.lastName = result.lastName
        self.dateOfBirth = result.dateOfBirth
        self.nationality = result.nationality
        self.issuer = result.issuer
        self.sex = result.sex
        self.mrzVerified = result.mrzVerified
        self.faceImage = result.faceImage?.image
    }
}