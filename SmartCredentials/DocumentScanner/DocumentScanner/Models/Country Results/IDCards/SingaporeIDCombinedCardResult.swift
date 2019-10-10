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

public class SingaporeIDCombinedCardResult: IDCardResult {
    
    public var identityCardNumber: String?
    public var race: String?
    public var sex: String?
    public var countryOfBirth: String?
    public var addressChangeDate: Date?
    public var bloodGroup: String?
    public var dateOfIssue: Date?
    
    init(with result: MBSingaporeCombinedRecognizerResult) {
        super.init()
        
        self.identityCardNumber = result.identityCardNumber
        self.firstName = result.name
        self.race = result.race
        self.sex = result.sex
        self.dateOfBirth = result.dateOfBirth?.date
        self.countryOfBirth = result.countryOfBirth
        self.address = result.address
        self.addressChangeDate = result.addressChangeDate.date
        self.bloodGroup = result.bloodGroup
        self.dateOfIssue = result.dateOfIssue.date
        self.faceImage = result.faceImage?.image
    }
}
