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

import XCTest
@testable import Core

class ItemPrivateDataTests: XCTestCase {
    
    func testIsEmptyItemPrivateData() {
        let privateData = ItemPrivateData(privateData: [:])
        XCTAssertTrue(privateData.privateData.isEmpty)
    }
    
    func testItemPrivateData() {
        let privateData = ItemPrivateData(privateData: [Constants.ItemPrivateData.key : Constants.ItemPrivateData.value])
        XCTAssertFalse(privateData.privateData.isEmpty)
        XCTAssertNotNil(privateData.privateData[Constants.ItemPrivateData.key])
        XCTAssertTrue(privateData.privateData[Constants.ItemPrivateData.key] is String)
        XCTAssertEqual(privateData.privateData[Constants.ItemPrivateData.key] as! String, Constants.ItemPrivateData.value)
    }
}
