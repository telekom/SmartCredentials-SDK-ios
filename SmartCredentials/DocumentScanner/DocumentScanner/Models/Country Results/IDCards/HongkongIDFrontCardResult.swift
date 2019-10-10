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

public class HongkongIDFrontCardResult: IDCardResult {
    
    public var commercialCode: String?
    public var sex: String?
    public var dateOfIssue: Date?
    public var residentialStatus: String?
    
    init(with result: MBHongKongIdFrontRecognizerResult) {
        super.init()
        
        self.firstName = result.fullName
        self.commercialCode = result.commercialCode
        self.dateOfBirth = result.dateOfBirth?.date
        self.sex = result.sex
        self.dateOfIssue = result.dateOfIssue?.date
        self.documentNumber = result.documentNumber
        self.residentialStatus = result.residentialStatus
        self.faceImage = result.faceImage?.image
    }
}
