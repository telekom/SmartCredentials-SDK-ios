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

public class CzechIDFrontCardResult: IDCardResult {
    
    public var identityCardNumber: String?
    public var rawDateOfBirth: String?
    public var rawDateOfIssue: String?
    public var dateOfIssue: Date?
    public var rawDateOfExpiry: String?
    public var dateOfExpiry: Date?
    public var sex: String?
    public var placeOfBirth: String?
    
    init(with result: MBCzechiaIdFrontRecognizerResult) {
        super.init()
        
        self.identityCardNumber = result.identityCardNumber
        self.firstName = result.firstName
        self.lastName = result.lastName
        self.rawDateOfBirth = result.rawDateOfBirth
        self.dateOfBirth = result.dateOfBirth
        self.rawDateOfIssue = result.rawDateOfIssue
        self.dateOfIssue = result.dateOfIssue
        self.rawDateOfExpiry = result.rawDateOfExpiry
        self.dateOfExpiry = result.dateOfExpiry
        self.sex = result.sex
        self.placeOfBirth = result.placeOfBirth
        self.faceImage = result.faceImage?.image
    }
}
