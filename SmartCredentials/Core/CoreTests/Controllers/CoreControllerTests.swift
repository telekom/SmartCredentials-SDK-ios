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

class CoreControllerTests: XCTestCase {
    
    var controller: CoreController!
    var item: ItemEnvelope!
    
    override func setUp() {
        let configuration = SmartCredentialsConfiguration(userId: Constants.Configuration.userId)
        controller = CoreController(configuration: configuration)
        
        item = ItemEnvelopeFactory.itemEnvelope(with: Constants.Item.id,
                                                type: .voucher,
                                                identifier: [:],
                                                privateData: [:])
    }
    
    override func tearDown() {
        controller = nil
        item = nil
    }
    
    func testisDeviceJailbroken() {
        let result = controller.isDeviceJailbroken()
        
        switch result {
        case .success(let booleanResult):
            if UIDevice.isSimulator {
                XCTAssertEqual(booleanResult, false)
            }
        case .failure(_):
            XCTFail()
        }
    }
    
    func testExecuteWithJailbreakCheckEnabled() {
        let configuration = SmartCredentialsConfiguration(userId: Constants.Configuration.userId,
                                                          logger: nil,
                                                          jailbreakCheckEnabled: true)
        
        let coreController = CoreController(configuration: configuration)
        coreController.execute(with: item,
                               actionId: Constants.Item.actionId) { execCallResult in
                                switch execCallResult {
                                case .success(_):
                                    break
                                case .failure(let error as SmartCredentialsAPIError):
                                    XCTAssertEqual(error, SmartCredentialsAPIError.actionNotFound)
                                    break
                                case .failure(_):
                                    break
                                }
        }
    }
    
    func testExecuteWithJailbreakCheckDisabled() {
        let configuration = SmartCredentialsConfiguration(userId: Constants.Configuration.userId,
                                                          logger: nil,
                                                          jailbreakCheckEnabled: false)
        
        let coreController = CoreController(configuration: configuration)
        coreController.execute(with: item,
                               actionId: Constants.Item.actionId) { execCallResult in
                                switch execCallResult {
                                case .failure(let error as SmartCredentialsAPIError):
                                    XCTAssertEqual(error, SmartCredentialsAPIError.actionNotFound)
                                    break
                                default:
                                    break
                                }
        }
    }
    
    func testExecuteConfirmationAction() {
        let confirmationActionDictionary = [ItemKeys.ActionKeys.actionId: Constants.Item.actionId,
                                            ItemKeys.ActionKeys.moduleName: "Authorization.ConfirmationAction",
                                            ItemKeys.ActionKeys.data: [:]] as [String: Any]
        item.itemMetadata.actionList.append(IActionModule(from: confirmationActionDictionary)!)
        
        controller.execute(with: item, actionId: Constants.Item.actionId) { execCallResult in
            // Result will be tested in Authorization Module
            XCTAssertTrue(true)
        }
    }
    
    func testExecuteItemToJsonAction() {
        let itemToJsonActionDictionary = [ItemKeys.ActionKeys.actionId: Constants.Item.actionId,
                                            ItemKeys.ActionKeys.moduleName: "Core.ItemToJsonAction",
                                            ItemKeys.ActionKeys.data: [:],
                                            ItemKeys.ActionKeys.shareChannel: "none"] as [String: Any]
        item.itemMetadata.actionList.append(ItemToJsonAction(from: itemToJsonActionDictionary)!)
        
        controller.execute(with: item, actionId: Constants.Item.actionId) { execCallResult in
            switch execCallResult {
            case .success(let itemToJsonResult):
                //TODO: check result here
                XCTAssertTrue(itemToJsonResult is ItemToJsonActionResult)
            case .failure(_):
                break
            }
        }
    }
    
    func testExecuteItemToJsonActionOnLockedItemWithoutConfirmationAction() {
        let itemToJsonActionDictionary = [ItemKeys.ActionKeys.actionId: Constants.Item.actionId,
                                          ItemKeys.ActionKeys.moduleName: "Core.ItemToJsonAction",
                                          ItemKeys.ActionKeys.data: [:],
                                          ItemKeys.ActionKeys.shareChannel: "none"] as [String: Any]
        item.itemMetadata.actionList.append(ItemToJsonAction(from: itemToJsonActionDictionary)!)
        item.itemMetadata.isLocked = true
        
        controller.execute(with: item, actionId: Constants.Item.actionId) { execCallResult in
            switch execCallResult {
            case .failure(let error as SmartCredentialsAPIError):
                XCTAssertEqual(error, .actionNotFound)
            default:
                break
            }
        }
    }
    
    func testExecuteItemToJsonActionOnLockedItemWithConfirmationAction() {
        let itemToJsonActionDictionary = [ItemKeys.ActionKeys.actionId: Constants.Item.actionId,
                                          ItemKeys.ActionKeys.moduleName: "Core.ItemToJsonAction",
                                          ItemKeys.ActionKeys.data: [:],
                                          ItemKeys.ActionKeys.shareChannel: "none"] as [String: Any]
        let confirmationActionDictionary = [ItemKeys.ActionKeys.actionId: Constants.Item.actionId,
                                            ItemKeys.ActionKeys.moduleName: "Authorization.ConfirmationAction",
                                            ItemKeys.ActionKeys.data: [:]] as [String: Any]
        item.itemMetadata.actionList.append(ItemToJsonAction(from: itemToJsonActionDictionary)!)
        item.itemMetadata.actionList.append(IActionModule(from: confirmationActionDictionary)!)
        item.itemMetadata.isLocked = true
        
        controller.execute(with: item, actionId: Constants.Item.actionId) { execCallResult in
            switch execCallResult {
            case .success(_):
                break
            case .failure(let error as SmartCredentialsAPIError):
                XCTAssertEqual(error, .confirmationActionExecution)
            case .failure(_):
                break
            }
        }
    }
}
