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

public class IndonesiaIDFrontCardResult: IDCardResult {
    
    public var bloodType: String?
    public var citizenship: String?
    public var city: String?
    public var dateOfExpiry: Date?
    public var dateOfExpiryPermanent: Bool?
    public var district: String?
    public var kelDesa: String?
    public var maritalStatus: String?
    public var occupation: String?
    public var placeOfBirth: String?
    public var province: String?
    public var religion: String?
    public var rt: String?
    public var rw: String?
    public var sex: String?
    
    init(with result: MBIndonesiaIdFrontRecognizerResult) {
        super.init()
        
        self.address = result.address
        self.bloodType = result.bloodType
        self.citizenship = result.citizenship
        self.city = result.city
        self.dateOfBirth = result.dateOfBirth.date
        self.dateOfExpiry = result.dateOfExpiry.date
        self.dateOfExpiryPermanent = result.dateOfExpiryPermanent
        self.district = result.district
        self.documentNumber = result.documentNumber
        self.kelDesa = result.kelDesa
        self.maritalStatus = result.maritalStatus
        self.firstName = result.name
        self.occupation = result.occupation
        self.placeOfBirth = result.placeOfBirth
        self.province = result.province
        self.religion = result.religion
        self.rt = result.rt
        self.rw = result.rw
        self.sex = result.sex
        self.faceImage = result.faceImage?.image
    }
}
