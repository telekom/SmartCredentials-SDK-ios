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

import CoreData
import Core

struct NonSensitiveStorageController: StorageProtocol {
    
    var userId: String
    let logger = LoggerProvider.sharedInstance.logger
    var className: String {
        get {
            return String(describing: type(of: self))
        }
    }
    
    // MARK: - API Methods Implementation
    func getSummary(for itemFilter: ItemFilter) -> SmartCredentialsAPIResult<ItemEnvelope> {
        let id = "\(userId)_\(itemFilter.itemId!)"
        
        guard let coreDataItemSummary = CoreDataItemSummary.find(by: id) else {
            logger?.log(.error, message: Constants.Logger.itemNotFound, className: className)
            return .failure(error: .itemNotFound)
        }
        
        var itemEnvelope = coreDataItemSummary.toItemEnvelope()
        itemEnvelope.itemId = itemFilter.itemId!
        
        return .success(result: itemEnvelope)
    }
    
    func getDetails(for itemFilter: ItemFilter) -> SmartCredentialsAPIResult<ItemEnvelope> {
        let id = "\(userId)_\(itemFilter.itemId!)"
        
        guard let coreDataItemSummary = CoreDataItemSummary.find(by: id) else {
            logger?.log(.error, message: Constants.Logger.itemNotFound, className: className)
            return .failure(error: .itemNotFound)
        }
        
        var itemEnvelope = coreDataItemSummary.toItemEnvelopeWithDetails()
        itemEnvelope.itemId = itemFilter.itemId!

        return .success(result: itemEnvelope)
    }

    func getAllItems() -> SmartCredentialsAPIResult<[ItemEnvelope]> {
        guard let coreDataItemSummaries = CoreDataItemSummary.findAll(for: userId) else {
            return .success(result: [])
        }
        
        let itemEnvelopes = coreDataItemSummaries.map({ coreDataItemSummary -> ItemEnvelope in
            var itemEnvelope = coreDataItemSummary.toItemEnvelope()

            if let range = itemEnvelope.itemId.range(of: "\(userId)_") {
                let itemId = itemEnvelope.itemId[range.upperBound..<itemEnvelope.itemId.endIndex]
                itemEnvelope.itemId = String(itemId)
            }
            
            return itemEnvelope
        })
        
        return .success(result: itemEnvelopes)
    }
    
    func getPasswordReference(for itemFilter: ItemFilter) -> SmartCredentialsAPIResult<Data> {
        // Returning error because getPasswordReference should be called only on sensitive repository
        return .failure(error: .invalidItemFilter)
    }
    
    func add(_ item: ItemEnvelope) -> SmartCredentialsAPIEmptyResult {
        var newItem = item
        newItem.itemId = "\(userId)_\(item.itemId)"
        
        let context = CoreDataHelper.sharedInstance.managedObjectContext
        if let coreDataItemSummary = CoreDataItemSummary.find(by: newItem.itemId) {
            newItem.update(coreDataItemSummary, in: context)
        } else {
            _ = newItem.toCoreDataItem(in: context)
        }
   
        do {
            try context.save()
        } catch {
            print(error)
            context.rollback()
            logger?.log(.error, message: Constants.Logger.saveError, className: className)
            return .failure(error: .saveError)
        }

        return .success
    }
    
    func add(_ genericPassword: String, with id: String) -> SmartCredentialsAPIEmptyResult {
        // Returning error because adding generic password should be called only on sensitive repository
        return .failure(error: .saveError)
    }
    
    func update(_ item: ItemEnvelope) -> SmartCredentialsAPIEmptyResult {
        var newItem = item
        newItem.itemId = "\(userId)_\(item.itemId)"
        
        let context = CoreDataHelper.sharedInstance.managedObjectContext
        guard let coreDataItemSummary = CoreDataItemSummary.find(by: newItem.itemId) else {
            return .failure(error: .itemNotFound)
        }
        
        newItem.update(coreDataItemSummary, in: context)
        
        do {
            try context.save()
        } catch {
            context.rollback()
            return .failure(error: .saveError)
        }
        
        return .success
    }
    
    func removeItem(for itemFilter: ItemFilter) -> SmartCredentialsAPIEmptyResult {
        let id = "\(userId)_\(itemFilter.itemId!)"
        
        let context = CoreDataHelper.sharedInstance.managedObjectContext
        guard let coreDataItemSummary = CoreDataItemSummary.find(by: id) else {
            logger?.log(.error, message: Constants.Logger.itemNotFound, className: className)
            return .failure(error: .itemNotFound)
        }

        context.delete(coreDataItemSummary)
        
        do {
            try context.save()
        } catch {
            context.rollback()
            logger?.log(.error, message: Constants.Logger.saveError, className: className)
            return .failure(error: .saveError)
        }
        
        return .success
    }
    
    func removeAllItems() -> SmartCredentialsAPIEmptyResult {
        guard let coreDataItemSummaries = CoreDataItemSummary.findAll(for: userId) else {
            return .success
        }
        
        let context = CoreDataHelper.sharedInstance.managedObjectContext
        for item in coreDataItemSummaries {
            context.delete(item)
        }
        
        do {
            try context.save()
        } catch {
            context.rollback()
            logger?.log(.error, message: Constants.Logger.saveError, className: className)
            return .failure(error: .saveError)
        }
        
        return .success
    }
}

// MARK: - ItemEnvelope - to CoreData item
extension ItemEnvelope {
    
    func toCoreDataItem(in context: NSManagedObjectContext) -> CoreDataItemSummary {
        // CoreDataItemSummary
        let entity = NSEntityDescription.entity(forEntityName: CoreDataItemSummary.entityName, in: context)!
        let coreDataItemSummary = CoreDataItemSummary(entity: entity, insertInto: context)
        
        update(coreDataItemSummary, in: context)

        return coreDataItemSummary
    }
    
    func update(_ coreDataItem: CoreDataItemSummary, in context: NSManagedObjectContext) {
        // CoreDataItemDetails
        let detailsEntity = NSEntityDescription.entity(forEntityName: CoreDataItemDetails.entityName, in: context)!
        let coreDataItemDetails = CoreDataItemDetails(entity: detailsEntity, insertInto: context)
        coreDataItemDetails.itemPrivateData = NSKeyedArchiver.archivedData(withRootObject: itemMetadata.itemPrivateData.privateData)

        coreDataItem.itemId = itemId
        coreDataItem.itemType = Int32(itemType.rawValue)
        coreDataItem.channel = itemMetadata.channel.rawValue
        coreDataItem.itemIdentifier = NSKeyedArchiver.archivedData(withRootObject: identifier)
        coreDataItem.itemDetails = coreDataItemDetails
        coreDataItem.actionList = NSKeyedArchiver.archivedData(withRootObject: itemMetadata.actionList)
        coreDataItem.isLocked = itemMetadata.isLocked
        coreDataItem.autoLock = itemMetadata.autoLocked
    }
}
