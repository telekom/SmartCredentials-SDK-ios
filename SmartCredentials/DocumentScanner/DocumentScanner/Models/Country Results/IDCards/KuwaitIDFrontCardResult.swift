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

public class KuwaitIDFrontCardResult: IDCardResult {
    
    public var civilIdNumber: String?
    public var expiryDate: Date?
    public var nationality: String?
    public var sex: String?
    
    init(with result: MBKuwaitIdFrontRecognizerResult) {
        super.init()
        
        self.dateOfBirth = result.birthDate.date
        self.civilIdNumber = result.civilIdNumber
        self.expiryDate = result.expiryDate.date
        self.firstName = result.name
        self.nationality = result.nationality
        self.sex = result.sex
        self.faceImage = result.faceImage?.image
    }
}
