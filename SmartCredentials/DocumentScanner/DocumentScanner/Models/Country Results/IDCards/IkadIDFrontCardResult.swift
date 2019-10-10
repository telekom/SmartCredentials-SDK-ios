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

public class IkadIDFrontCardResult: IDCardResult {
    
    public var dateOfExpiry: Date?
    public var employer: String?
    public var facultyAddress: String?
    public var gender: String?
    public var nationality: String?
    public var passportNumber: String?
    public var sector: String?
    
    init(with result: MBMalaysiaIkadFrontRecognizerResult) {
        super.init()
        
        self.address = result.address
        self.dateOfBirth = result.dateOfBirth.date
        self.dateOfExpiry = result.dateOfExpiry.date
        self.employer = result.employer
        self.facultyAddress = result.facultyAddress
        self.gender = result.gender
        self.firstName = result.name
        self.nationality = result.nationality
        self.passportNumber = result.passportNumber
        self.sector = result.sector
        self.faceImage = result.faceImage?.image
    }
}
