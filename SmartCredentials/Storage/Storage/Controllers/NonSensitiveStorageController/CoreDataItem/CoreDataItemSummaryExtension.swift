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

#if canImport(Core)
import Core
#endif


extension CoreDataItemSummary {
    
    func toItemEnvelope() -> ItemEnvelope {
        let itemPrivateData = ItemPrivateData(privateData: [:])
        
        var itemChannel: Channel = .typeUnknown
        if let channelString = channel {
            if let channel = Channel(rawValue: channelString) {
                itemChannel = channel
            }
        }
        
        var actions: [IActionModule] = []
        if let actionListData = actionList {
            if let actionListArray = NSKeyedUnarchiver.unarchiveObject(with: actionListData) as? [IActionModule] {
                actions = actionListArray
            }
        }

        let itemMetadata = ItemMetadata(channel: itemChannel, actionList: actions, itemPrivateData: itemPrivateData, isLocked: isLocked, autoLocked: autoLock)
        
        var identifier: [String: Any] = [:]
        
        if let itemIdentifier = itemIdentifier {
            if let itemIdentifierDict = NSKeyedUnarchiver.unarchiveObject(with: itemIdentifier) as? [String: Any] {
                identifier = itemIdentifierDict
            }
        }
        
        var type: ItemType = .other
        if let itemType = ItemType(rawValue: Int(itemType)) {
            type = itemType
        }
        
        return ItemEnvelope(identifier: identifier, itemId: itemId!, itemType: type, itemMetadata: itemMetadata)
    }
    
    func toItemEnvelopeWithDetails() -> ItemEnvelope {
        var itemEnvelope = toItemEnvelope()
        
        var itemPrivateData: [String: Any] = [:]
        if let itemDetails = itemDetails {
            if let privateData = itemDetails.itemPrivateData {
                if let itemPrivateDataDict = NSKeyedUnarchiver.unarchiveObject(with: privateData) as? [String: Any] {
                    itemPrivateData = itemPrivateDataDict
                }
            }
        }
        
        itemEnvelope.itemMetadata.itemPrivateData.privateData = itemPrivateData
        
        return itemEnvelope
    }
    
    static func find(by itemId: String) -> CoreDataItemSummary? {
        let fetchRequest = NSFetchRequest<CoreDataItemSummary>(entityName: CoreDataItemSummary.entityName)
        fetchRequest.predicate = NSPredicate(format: "itemId = %@", itemId)
        fetchRequest.fetchLimit = 1
        
        let context = CoreDataHelper.sharedInstance.managedObjectContext
        guard let result = try? context.fetch(fetchRequest) else {
            return nil
        }
        
        return result.first
    }
    
    static func findAll(for userId: String) -> [CoreDataItemSummary]? {
        let fetchRequest = NSFetchRequest<CoreDataItemSummary>(entityName: CoreDataItemSummary.entityName)
        
        let context = CoreDataHelper.sharedInstance.managedObjectContext
        guard let result = try? context.fetch(fetchRequest) else {
            return nil
        }
        
        var items: [CoreDataItemSummary] = []
        for item in result {
            guard let itemId = item.itemId else {
                continue
            }
            
            guard let userIdRange = itemId.range(of: "\(userId)_") else {
                continue
            }
            
            if userIdRange.lowerBound == itemId.startIndex {
                items.append(item)
            }
        }
        
        return items
    }
    
}
