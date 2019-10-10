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

/// Object used for returning the result obtained from OCRScanner
public struct OCRScannerResult {
 
    /// String representing text recognised by OCRScanner
    public var recognizedText: String
    
    /// UIImage representing the last image processed by OCRScanner
    public var lastImage: UIImage
    
    public init(recognizedText: String, lastImage: UIImage) {
        self.recognizedText = recognizedText
        self.lastImage = lastImage
    }
}
