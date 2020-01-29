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

import Foundation
import Core

class DefaultStorageController {
    
    let logger = LoggerProvider.sharedInstance.logger
    var configuration: SmartCredentialsConfiguration
    
    // MARK: - Initializers
    init(configuration: SmartCredentialsConfiguration) {
        self.configuration = configuration
    }
    
    // MARK: - Jailbreak Check
    private func isJailbroken() -> Bool {
        if configuration.jailbreakCheckEnabled {
            return JailbreakDetection.isJailbroken()
        }
        return false
    }
}

// MARK: - Storage API
extension DefaultStorageController: StorageAPI {
    func getItemSummary(for itemFilter: ItemFilter) -> SmartCredentialsAPIResult<ItemEnvelope> {
        guard isJailbroken() == false else {
            CoreDataHelper.sharedInstance.deleteAllDataForEntity(with: CoreDataItemSummary.entityName)
            KeychainHelper.standard.removeAllKeys()
            logger?.log(.error, message: Constants.Logger.jailbreakError, className: className)
            return .failure(error: .jailbreakDetected)
        }
        
        guard let _ = itemFilter.itemId else {
            logger?.log(.error, message: Constants.Logger.itemFilterError, className: className)
            return .failure(error: .invalidItemFilter)
        }
        
        let storageController = StorageControllerProvider.storageController(for: itemFilter.contentType,
                                                                            sensitiveItemAccessibility: itemFilter.sensitiveItemAccessibility,
                                                                            userId: configuration.userId)
        return storageController.getSummary(for: itemFilter)
    }
    
    func getItemDetails(for itemFilter: ItemFilter) -> SmartCredentialsAPIResult<ItemEnvelope> {
        guard isJailbroken() == false else {
            CoreDataHelper.sharedInstance.deleteAllDataForEntity(with: CoreDataItemSummary.entityName)
            KeychainHelper.standard.removeAllKeys()
            logger?.log(.error, message: Constants.Logger.jailbreakError, className: className)
            return .failure(error: .jailbreakDetected)
        }
        
        guard let _ = itemFilter.itemId else {
            logger?.log(.error, message: Constants.Logger.itemFilterError, className: className)
            return .failure(error: .invalidItemFilter)
        }
        
        let storageController = StorageControllerProvider.storageController(for: itemFilter.contentType,
                                                                            sensitiveItemAccessibility: itemFilter.sensitiveItemAccessibility,
                                                                            userId: configuration.userId)
        return storageController.getDetails(for: itemFilter)
    }
    
    func getAllItems(for itemFilter: ItemFilter) -> SmartCredentialsAPIResult<[ItemEnvelope]> {
        guard isJailbroken() == false else {
            CoreDataHelper.sharedInstance.deleteAllDataForEntity(with: CoreDataItemSummary.entityName)
            KeychainHelper.standard.removeAllKeys()
            logger?.log(.error, message: Constants.Logger.jailbreakError, className: className)
            return .failure(error: .jailbreakDetected)
        }
        
        let storageController = StorageControllerProvider.storageController(for: itemFilter.contentType,
                                                                            sensitiveItemAccessibility: itemFilter.sensitiveItemAccessibility,
                                                                            userId: configuration.userId)
        return storageController.getAllItems()
    }
    
    func getPasswordReference(for itemFilter: ItemFilter) -> SmartCredentialsAPIResult<Data> {
        guard isJailbroken() == false else {
            CoreDataHelper.sharedInstance.deleteAllDataForEntity(with: CoreDataItemSummary.entityName)
            KeychainHelper.standard.removeAllKeys()
            logger?.log(.error, message: Constants.Logger.jailbreakError, className: className)
            return .failure(error: .jailbreakDetected)
        }
        
        guard let _ = itemFilter.itemId else {
            logger?.log(.error, message: Constants.Logger.itemFilterError, className: className)
            return .failure(error: .invalidItemFilter)
        }
        
        let storageController = StorageControllerProvider.storageController(for: itemFilter.contentType,
                                                                            sensitiveItemAccessibility: itemFilter.sensitiveItemAccessibility,
                                                                            userId: configuration.userId)
        return storageController.getPasswordReference(for: itemFilter)
    }
    
    func put(_ item: ItemEnvelope, with itemContext: ItemContext) -> SmartCredentialsAPIEmptyResult {
        guard isJailbroken() == false else {
            CoreDataHelper.sharedInstance.deleteAllDataForEntity(with: CoreDataItemSummary.entityName)
            KeychainHelper.standard.removeAllKeys()
            logger?.log(.error, message: Constants.Logger.jailbreakError, className: className)
            return .failure(error: .jailbreakDetected)
        }
        
        let storageController = StorageControllerProvider.storageController(for: itemContext.contentType,
                                                                            sensitiveItemAccessibility: itemContext.sensitiveItemAccessibility,
                                                                            userId: configuration.userId)
        return storageController.add(item)
    }
    
    func put(_ genericPassword: String, with id: String, sensitiveItemAccessibility: KeychainItemAccessibility) -> SmartCredentialsAPIEmptyResult {
        guard isJailbroken() == false else {
            CoreDataHelper.sharedInstance.deleteAllDataForEntity(with: CoreDataItemSummary.entityName)
            KeychainHelper.standard.removeAllKeys()
            logger?.log(.error, message: Constants.Logger.jailbreakError, className: className)
            return .failure(error: .jailbreakDetected)
        }
        
        let storageController = StorageControllerProvider.storageController(for: .sensitive,
                                                                            sensitiveItemAccessibility: sensitiveItemAccessibility,
                                                                            userId: configuration.userId)
        return storageController.add(genericPassword, with: id)
    }
    
    func update(_ item: ItemEnvelope, with itemContext: ItemContext) -> SmartCredentialsAPIEmptyResult {
        guard isJailbroken() == false else {
            CoreDataHelper.sharedInstance.deleteAllDataForEntity(with: CoreDataItemSummary.entityName)
            KeychainHelper.standard.removeAllKeys()
            return .failure(error: .jailbreakDetected)
        }
        
        let storageController = StorageControllerProvider.storageController(for: itemContext.contentType,
                                                                            sensitiveItemAccessibility: itemContext.sensitiveItemAccessibility,
                                                                            userId: configuration.userId)
        return storageController.update(item)
    }
    
    func removeItem(for itemFilter: ItemFilter) -> SmartCredentialsAPIEmptyResult {
        guard isJailbroken() == false else {
            CoreDataHelper.sharedInstance.deleteAllDataForEntity(with: CoreDataItemSummary.entityName)
            KeychainHelper.standard.removeAllKeys()
            logger?.log(.error, message: Constants.Logger.jailbreakError, className: className)
            return .failure(error: .jailbreakDetected)
        }
        
        guard let _ = itemFilter.itemId else {
            logger?.log(.error, message: Constants.Logger.itemFilterError, className: className)
            return .failure(error: .invalidItemFilter)
        }
        
        let storageController = StorageControllerProvider.storageController(for: itemFilter.contentType,
                                                                            sensitiveItemAccessibility: itemFilter.sensitiveItemAccessibility,
                                                                            userId: configuration.userId)
        return storageController.removeItem(for: itemFilter)
    }
    
    func removeAllItems(for itemFilter: ItemFilter) -> SmartCredentialsAPIEmptyResult {
        guard isJailbroken() == false else {
            CoreDataHelper.sharedInstance.deleteAllDataForEntity(with: CoreDataItemSummary.entityName)
            KeychainHelper.standard.removeAllKeys()
            logger?.log(.error, message: Constants.Logger.jailbreakError, className: className)
            return .failure(error: .jailbreakDetected)
        }
        
        let storageController = StorageControllerProvider.storageController(for: itemFilter.contentType,
                                                                            sensitiveItemAccessibility: itemFilter.sensitiveItemAccessibility,
                                                                            userId: configuration.userId)
        return storageController.removeAllItems()
    }
}

extension DefaultStorageController: Nameable {
}
