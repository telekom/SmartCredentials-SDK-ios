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

import UIKit

#if canImport(Core)
import Core
#endif

public class IDCardResult: ScannerResult {
    
    public var faceImage: UIImage?
    public var firstName: String? = ""
    public var lastName: String? = ""
    public var dateOfBirth: Date?
    public var documentNumber: String? = ""
    public var personalNumber: String? = ""
    public var issuer: String? = ""
    public var address: String? = ""
    
    override init() {
    }
    
    public func setImage(image: UIImage?) {
        guard let imageX = image else {
            return
        }
        faceImage = imageX
    }
}
