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

public class CroatiaIDFrontCardResult: IDCardResult {

    public var sex: String?
    public var citizenship: String?
    public var dateOfExpiry: Date?
    public var dateOfExpiryPermanent: Bool = false
    public var documentBilingual: Bool = false
    
    init(with result: MBCroatiaIdFrontRecognizerResult) {
        super.init()
        
        self.firstName = result.firstName
        self.lastName = result.lastName
        self.documentNumber = result.documentNumber
        self.sex = result.sex
        self.citizenship = result.citizenship
        self.dateOfBirth = result.dateOfBirth?.date
        self.dateOfExpiry = result.dateOfExpiry?.date
        self.dateOfExpiryPermanent = result.dateOfExpiryPermanent
        self.documentBilingual = result.documentBilingual
        self.faceImage = result.faceImage?.image
    }
}
