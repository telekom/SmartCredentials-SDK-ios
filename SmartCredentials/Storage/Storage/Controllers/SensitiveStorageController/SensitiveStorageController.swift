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

#if canImport(Core)
import Core
#endif

struct SensitiveStorageController: StorageProtocol {

    var userId: String
    let logger = LoggerProvider.sharedInstance.logger
    var className: String {
        get {
            return String(describing: type(of: self))
        }
    }
    
    // MARK: - API Methods Implementation
    func add(_ item: ItemEnvelope) -> SmartCredentialsAPIEmptyResult {
        var newItem = item
        newItem.itemId = "\(userId)_\(item.itemId)"
        
        let keychainItem = newItem.toKeychainItem()
        if KeychainHelper.standard.set(keychainItem, forKey: newItem.itemId, withAccessibility: .whenUnlockedThisDeviceOnly) {
            return .success
        }
        
        logger?.log(.error, message: Constants.Logger.saveError, className: className)
        return .failure(error: .saveError)
    }
    
    func add(_ genericPassword: String, with id: String) -> SmartCredentialsAPIEmptyResult {
        let itemId = "\(userId)_\(id)"
        
        if KeychainHelper.standard.set(genericPassword, forKey: itemId, withAccessibility: .whenUnlockedThisDeviceOnly) {
            return .success
        }

        logger?.log(.error, message: Constants.Logger.saveError, className: className)
        return .failure(error: .saveError)
    }
    
    func update(_ item: ItemEnvelope) -> SmartCredentialsAPIEmptyResult {
        var newItem = item
        newItem.itemId = "\(userId)_\(item.itemId)"
        
        guard let _ = KeychainHelper.standard.object(forKey: newItem.itemId, withAccessibility: .whenUnlockedThisDeviceOnly) as? KeychainItemSummary else {
            return .failure(error: .itemNotFound)
        }

        let keychainItem = newItem.toKeychainItem()
        if KeychainHelper.standard.set(keychainItem, forKey: newItem.itemId, withAccessibility: .whenUnlockedThisDeviceOnly) {
            return .success
        }
        
        return .failure(error: .saveError)
    }
    
    func getSummary(for itemFilter: ItemFilter) -> SmartCredentialsAPIResult<ItemEnvelope> {
        let id = "\(userId)_\(itemFilter.itemId!)"

        guard let keychainItemSummary = KeychainHelper.standard.object(forKey: id, withAccessibility: .whenUnlockedThisDeviceOnly) as? KeychainItemSummary else {
            logger?.log(.error, message: Constants.Logger.itemNotFound, className: className)
            return .failure(error: .itemNotFound)
        }
        
        var itemEnvelope = keychainItemSummary.toItemEnvelope()
        itemEnvelope.itemId = itemFilter.itemId!

        return .success(result: itemEnvelope)
    }
    
    func getDetails(for itemFilter: ItemFilter) -> SmartCredentialsAPIResult<ItemEnvelope> {
        let id = "\(userId)_\(itemFilter.itemId!)"

        guard let keychainItemSummary = KeychainHelper.standard.object(forKey: id, withAccessibility: .whenUnlockedThisDeviceOnly) as? KeychainItemSummary else {
            logger?.log(.error, message: Constants.Logger.itemNotFound, className: className)
            return .failure(error: .itemNotFound)
        }

        var itemEnvelope = keychainItemSummary.toItemEnvelopeWithDetails()
        itemEnvelope.itemId = itemFilter.itemId!
        
        return .success(result: itemEnvelope)
    }
    
    func getAllItems() -> SmartCredentialsAPIResult<[ItemEnvelope]> {
        var itemEnvelopes: [ItemEnvelope] = []
        
        let keys = KeychainHelper.standard.allKeys()
        for key in keys {
            guard let keychainItemSummary = KeychainHelper.standard.object(forKey: key, withAccessibility: .whenUnlockedThisDeviceOnly) as? KeychainItemSummary else {
                continue
            }
            
            var itemEnvelope = keychainItemSummary.toItemEnvelope()
            
            guard let userIdRange = itemEnvelope.itemId.range(of: "\(userId)_") else {
                continue
            }
            
            if userIdRange.lowerBound == itemEnvelope.itemId.startIndex {
                let itemId = itemEnvelope.itemId[userIdRange.upperBound..<itemEnvelope.itemId.endIndex]
                itemEnvelope.itemId = String(itemId)
                itemEnvelopes.append(itemEnvelope)
            }
        }
        
        return .success(result: itemEnvelopes)
    }
    
    func getPasswordReference(for itemFilter: ItemFilter) -> SmartCredentialsAPIResult<Data> {
        let id = "\(userId)_\(itemFilter.itemId!)"
        
        guard let referenceData = KeychainHelper.standard.dataRef(forKey: id, withAccessibility: .whenUnlockedThisDeviceOnly) else {
            logger?.log(.error, message: Constants.Logger.itemNotFound, className: className)
            return .failure(error: .itemNotFound)
        }
        
        return .success(result: referenceData)
    }
    
    func removeItem(for itemFilter: ItemFilter) -> SmartCredentialsAPIEmptyResult {
        let id = "\(userId)_\(itemFilter.itemId!)"
        
        let item = KeychainHelper.standard.object(forKey: id, withAccessibility: .whenUnlockedThisDeviceOnly)
        let password = KeychainHelper.standard.string(forKey: id, withAccessibility: .whenUnlockedThisDeviceOnly)
        
        if item == nil && password == nil {
            logger?.log(.error, message: Constants.Logger.itemNotFound, className: className)
            return .failure(error: .itemNotFound)
        }

        if KeychainHelper.standard.removeObject(forKey: id, withAccessibility: .whenUnlockedThisDeviceOnly) {
            return .success
        }
        
        logger?.log(.error, message: Constants.Logger.saveError, className: className)
        return .failure(error: .saveError)
    }
    
    func removeAllItems() -> SmartCredentialsAPIEmptyResult {
        let keys = KeychainHelper.standard.allKeys()
        for key in keys {
            let keychainItemSummary = KeychainHelper.standard.object(forKey: key, withAccessibility: .whenUnlockedThisDeviceOnly) as? KeychainItemSummary
            let genericPassword = KeychainHelper.standard.string(forKey: key, withAccessibility: .whenUnlockedThisDeviceOnly)
            
            if keychainItemSummary == nil && genericPassword == nil {
                continue
            }
            
            guard let userIdRange = key.range(of: "\(userId)_") else {
                continue
            }
            
            if userIdRange.lowerBound == key.startIndex {
                KeychainHelper.standard.removeObject(forKey: key, withAccessibility: .whenUnlockedThisDeviceOnly)
            }
        }

        return .success
    }
}

// MARK: - ItemEnvelope - to Keychain item
extension ItemEnvelope {
    func toKeychainItem() -> KeychainItemSummary {
        let keychainItemDetails = KeychainItemDetails(itemPrivateData: itemMetadata.itemPrivateData.privateData)

        return KeychainItemSummary(itemId: itemId,
                                   itemIdentifier: identifier,
                                   itemType: itemType,
                                   channel: itemMetadata.channel,
                                   keychainItemDetails: keychainItemDetails,
                                   actionList: itemMetadata.actionList,
                                   isLocked: itemMetadata.isLocked,
                                   autoLocked: itemMetadata.autoLocked)
    }
}
