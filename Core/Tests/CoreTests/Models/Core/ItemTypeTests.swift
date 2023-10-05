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

class ItemTypeTests: XCTestCase {
    
    func testVoucherItemType() {
        let itemType = ItemType(rawValue: Constants.ItemType.voucherRawValue)
        XCTAssertEqual(itemType, .voucher)
    }
    
    func testTokenItemType() {
        let itemType = ItemType(rawValue: Constants.ItemType.tokenRawValue)
        XCTAssertEqual(itemType, .token)
    }
    
    func testOtherItemType() {
        let itemType = ItemType(rawValue: Constants.ItemType.otherRawValue)
        XCTAssertEqual(itemType, .other)
    }
    
    func testToString() {
        let itemTypeVoucher = ItemType(rawValue: Constants.ItemType.voucherRawValue)
        XCTAssertEqual(itemTypeVoucher?.toString(), Constants.ItemType.voucher)
        
        let itemTypeToken = ItemType(rawValue: Constants.ItemType.tokenRawValue)
        XCTAssertEqual(itemTypeToken?.toString(), Constants.ItemType.token)
        
        let itemTypeOther = ItemType(rawValue: Constants.ItemType.otherRawValue)
        XCTAssertEqual(itemTypeOther?.toString(), Constants.ItemType.other)
        
        let itemTypeTOTP = ItemType(rawValue: Constants.ItemType.totpRawValue)
        XCTAssertEqual(itemTypeTOTP?.toString(), Constants.ItemType.totp)
        
        let itemTypeHOTP = ItemType(rawValue: Constants.ItemType.hotpRawValue)
        XCTAssertEqual(itemTypeHOTP?.toString(), Constants.ItemType.hotp)
    }
    
    func testToItemType() {
        let voucherItemType = ItemType.toItemType(typeAsString: Constants.ItemType.voucher)
        XCTAssertNotNil(voucherItemType)
        XCTAssertEqual(voucherItemType, .voucher)
        
        let tokenItemType = ItemType.toItemType(typeAsString: Constants.ItemType.token)
        XCTAssertNotNil(tokenItemType)
        XCTAssertEqual(tokenItemType, .token)
        
        let otherItemType = ItemType.toItemType(typeAsString: Constants.ItemType.other)
        XCTAssertNotNil(otherItemType)
        XCTAssertEqual(otherItemType, .other)
        
        let totpItemType = ItemType.toItemType(typeAsString: Constants.ItemType.totp)
        XCTAssertNotNil(totpItemType)
        XCTAssertEqual(totpItemType, .totp)
        
        let hotpItemType = ItemType.toItemType(typeAsString: Constants.ItemType.hotp)
        XCTAssertNotNil(hotpItemType)
        XCTAssertEqual(hotpItemType, .hotp)
    }
    
    func testToItemTypeIncorrectString() {
        let voucherItemType = ItemType.toItemType(typeAsString: Constants.ItemType.incorrectStringType)
        XCTAssertNil(voucherItemType)
    }
}

//static func toItemType(typeAsString: String) -> ItemType? {
//    let type = typeAsString.lowercased()
//    switch type {
//    case "voucher":
//        return ItemType.voucher
//    case "token":
//        return ItemType.token
//    case "other":
//        return ItemType.other
//    case "totp":
//        return ItemType.totp
//    case "hotp":
//        return ItemType.hotp
//    default:
//        return nil
//    }
//}

