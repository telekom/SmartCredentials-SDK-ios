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

public class SwitzerlandIDBackCardResult: IDCardResult {
    
    public var authority: String?
    public var dateOfExpiry: Date?
    public var dateOfIssue: Date?
    public var height: String?
    public var mrzResult: String?
    public var placeOfOrigin: String?
    public var sex: String?
    
    init(with result: MBSwitzerlandIdBackRecognizerResult) {
        super.init()
        
        self.authority = result.authority
        self.dateOfExpiry = result.dateOfExpiry.date
        self.dateOfIssue = result.dateOfIssue.date
        self.height = result.height
        self.mrzResult = result.mrzResult.mrzText
        self.placeOfOrigin = result.placeOfOrigin
        self.sex = result.sex
    }
    
}
