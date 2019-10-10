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

class ItemEnvelopeFactoryTests: XCTestCase {
    
    func testCreateItemFromValidJSONAtPath() {
        let testBundle = Bundle(for: type(of: self))
        let fileURL = testBundle.url(forResource: "item_json_format", withExtension: "json")!
        
        let item = ItemEnvelopeFactory.itemEnvelope(fromJSONAt: fileURL)
        XCTAssertNotNil(item)
        
        XCTAssertEqual(item!.itemId, Constants.Item.id)
        XCTAssertEqual(item!.itemType, .token)
    }
    
    func testCreateItemFromInvalidJSONAtPath() {
        let testBundle = Bundle(for: type(of: self))
        let fileURL = testBundle.url(forResource: "item_json_format_invalid", withExtension: "json")!
        
        let item = ItemEnvelopeFactory.itemEnvelope(fromJSONAt: fileURL)
        XCTAssertNil(item)
    }
    
    func testCreateItemFromWrongJSONAtPath() {
        let testBundle = Bundle(for: type(of: self))
        let fileURL = testBundle.url(forResource: "item_json_format_list", withExtension: "json")!
        
        let item = ItemEnvelopeFactory.itemEnvelope(fromJSONAt: fileURL)
        XCTAssertNil(item)
    }
    
    func testCreateItemFromDictionaryWithInvalidId() {
        let dictionary = [ItemKeys.id: 1]
        
        let item = ItemEnvelopeFactory.itemEnvelope(from: dictionary)
        XCTAssertNil(item)
    }
    
    func testCreateItemFromDictionaryWithInvalidItemType() {
        let dictionary1 = [ItemKeys.id: Constants.Item.id,
                           ItemKeys.type: 1] as [String: Any]
        
        let item1 = ItemEnvelopeFactory.itemEnvelope(from: dictionary1)
        XCTAssertNil(item1)
        
        let dictionary2 = [ItemKeys.id: Constants.Item.id,
                           ItemKeys.type: "invalid_type"]
        
        let item2 = ItemEnvelopeFactory.itemEnvelope(from: dictionary2)
        XCTAssertNil(item2)
    }
    
    func testCreateItemFromDictionaryWithInvalidIdentifier() {
        let dictionary = [ItemKeys.id: Constants.Item.id,
                          ItemKeys.type: Constants.ItemType.voucher]
        
        let item = ItemEnvelopeFactory.itemEnvelope(from: dictionary)
        XCTAssertNil(item)
    }
    
    func testCreateItemFromDictionaryWithInvalidMetadata() {
        let dictionary = [ItemKeys.id: Constants.Item.id,
                          ItemKeys.type: Constants.ItemType.voucher,
                          ItemKeys.identifier: [:]] as [String: Any]
        
        let item = ItemEnvelopeFactory.itemEnvelope(from: dictionary)
        XCTAssertNil(item)
    }
    
    func testCreateItemFromDictionaryWithInvalidPrivateData() {
        let dictionary = [ItemKeys.id: Constants.Item.id,
                          ItemKeys.type: Constants.ItemType.voucher,
                          ItemKeys.identifier: [:],
                          ItemKeys.metadata: [:],
                          ItemKeys.actions: []] as [String: Any]
        
        let item = ItemEnvelopeFactory.itemEnvelope(from: dictionary)
        XCTAssertNil(item)
    }
    
    func testCreateItemFromDictionaryWithNoActions() {
        let dictionary = [ItemKeys.id: Constants.Item.id,
                          ItemKeys.type: Constants.ItemType.voucher,
                          ItemKeys.identifier: [:],
                          ItemKeys.metadata: [ItemKeys.actions: [],
                                              ItemKeys.privateData: [:]]] as [String: Any]
        
        let item = ItemEnvelopeFactory.itemEnvelope(from: dictionary)
        XCTAssertNotNil(item)
    }
    
    func testCreateItemFromDictionaryWithActions() {
        let actionDictionary = [ItemKeys.ActionKeys.moduleName: 1,
                                 ItemKeys.ActionKeys.actionId: "",
                                 ItemKeys.ActionKeys.data: [:],
                                 ItemKeys.ActionKeys.shareChannel: "none"] as [String: Any]
        let actionDictionary1 = [ItemKeys.ActionKeys.moduleName: "Core.ItemToJsonAction",
                                ItemKeys.ActionKeys.actionId: "",
                                ItemKeys.ActionKeys.data: [:],
                                ItemKeys.ActionKeys.shareChannel: "none"] as [String: Any]
        let actionDictionary2 = [ItemKeys.ActionKeys.moduleName: "Core.ItemToJsonAction",
                                ItemKeys.ActionKeys.actionId: 1,
                                ItemKeys.ActionKeys.data: [:],
                                ItemKeys.ActionKeys.shareChannel: "none"] as [String: Any]
        let actionDictionary3 = [ItemKeys.ActionKeys.moduleName: "Core.ItemToJsonAction",
                                ItemKeys.ActionKeys.actionId: "",
                                ItemKeys.ActionKeys.data: "",
                                ItemKeys.ActionKeys.shareChannel: "none"] as [String: Any]
        let actionDictionary4 = [ItemKeys.ActionKeys.moduleName: "Core.ItemToJsonAction",
                                 ItemKeys.ActionKeys.actionId: "",
                                 ItemKeys.ActionKeys.data: "",
                                 ItemKeys.ActionKeys.shareChannel: ""] as [String: Any]
        let actionDictionary5 = [ItemKeys.ActionKeys.moduleName: "Core.ItemToJsonAction",
                                 ItemKeys.ActionKeys.actionId: "",
                                 ItemKeys.ActionKeys.data: "",
                                 ItemKeys.ActionKeys.shareChannel: 1] as [String: Any]
        
        let dictionary = [ItemKeys.id: Constants.Item.id,
                          ItemKeys.type: Constants.ItemType.voucher,
                          ItemKeys.identifier: [:],
                          ItemKeys.metadata: [ItemKeys.actions: [actionDictionary, actionDictionary1, actionDictionary2, actionDictionary3, actionDictionary4, actionDictionary5],
                                              ItemKeys.privateData: [:]]] as [String: Any]
        
        let item = ItemEnvelopeFactory.itemEnvelope(from: dictionary)
        XCTAssertNotNil(item)
    }
    
    func testCreateItem() {
        var item = ItemEnvelopeFactory.itemEnvelope(with: Constants.Item.id,
                                                    type: .voucher,
                                                    identifier: [:],
                                                    privateData: [:])
        XCTAssertNotNil(item)
        
        item = ItemEnvelopeFactory.itemEnvelope(with: Constants.Item.id,
                                                type: .voucher,
                                                identifier: [:],
                                                privateData: [:],
                                                actionList: [])
        
        XCTAssertNotNil(item)
        
        item = ItemEnvelopeFactory.itemEnvelope(with: Constants.Item.id,
                                                type: .voucher,
                                                identifier: [:],
                                                privateData: [:],
                                                actionList: [],
                                                isLocked: false,
                                                autoLocked: false)
        
        XCTAssertNotNil(item)
    }
}
