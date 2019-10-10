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

public class MyKadIdFrontCardResult: IDCardResult {
    
    public var city: String?
    public var fullAddress: String?
    public var fullName: String?
    public var nric: String?
    public var ownerState: String?
    public var religion: String?
    public var sex: String?
    public var street: String?
    public var zipcode: String?
    
    init(with result: MBMalaysiaMyKadFrontRecognizerResult) {
        super.init()
        
        self.dateOfBirth = result.birthDate.date
        self.city = result.city
        self.fullAddress = result.fullAddress
        self.fullName = result.fullName
        self.nric = result.nric
        self.ownerState = result.ownerState
        self.religion = result.religion
        self.sex = result.sex
        self.street = result.street
        self.zipcode = result.zipcode
        self.faceImage = result.faceImage?.image
    }
}
