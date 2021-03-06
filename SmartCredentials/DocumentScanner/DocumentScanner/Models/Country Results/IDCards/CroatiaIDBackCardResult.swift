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

public class CroatiaIDBackCardResult: IDCardResult {
    
    public var dateOfIssue: Date?
    public var documentForNonResident: Bool = false
    public var dateOfExpiryPermanent: Bool = false
    public var mrzResult: String?
    
    init(with result: MBCroatiaIdBackRecognizerResult) {
        super.init()
        
        self.address = result.residence
        self.issuer = result.issuedBy
        self.dateOfIssue = result.dateOfIssue?.date
        self.documentForNonResident = result.documentForNonResident
        self.dateOfExpiryPermanent = result.dateOfExpiryPermanent
        self.mrzResult = result.mrzResult.mrzText
    }
}
