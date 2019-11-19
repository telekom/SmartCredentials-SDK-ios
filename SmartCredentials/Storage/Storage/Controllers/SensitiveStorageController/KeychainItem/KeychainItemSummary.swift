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

@objc class KeychainItemSummary: NSObject, NSCoding {
    
    var itemId: String
    var itemIdentifier: [String: Any] = [:]
    var itemType: ItemType
    var channel: Channel = .typeUnknown
    var keychainItemDetails: KeychainItemDetails
    var actionList: [IActionModule]
    var isLocked: Bool
    var autoLocked: Bool
    
    // MARK: - Initialization
    init(itemId: String, itemIdentifier: [String: Any], itemType: ItemType, channel: Channel, keychainItemDetails: KeychainItemDetails, actionList: [IActionModule], isLocked: Bool, autoLocked: Bool) {
        self.itemId = itemId
        self.itemIdentifier = itemIdentifier
        self.itemType = itemType
        self.channel = channel
        self.keychainItemDetails = keychainItemDetails
        self.actionList = actionList
        self.isLocked = isLocked
        self.autoLocked = autoLocked
    }

    // MARK: - NSCoding Protocol
    required convenience init?(coder decoder: NSCoder) {
        guard let itemIdentifierData = decoder.decodeObject(forKey: Constants.Keychain.itemIdentifier) as? Data,
            let channelValue = decoder.decodeObject(forKey: Constants.Keychain.channel) as? String,
            let keychainItemDetails = decoder.decodeObject(forKey: Constants.Keychain.keychainItemDetails) as? KeychainItemDetails else {
                return nil
        }

        guard let itemType = ItemType(rawValue: decoder.decodeInteger(forKey: Constants.Keychain.itemType)),
            let channel = Channel(rawValue: channelValue) else {
            return nil
        }
        
        guard let itemIdentifier = NSKeyedUnarchiver.unarchiveObject(with: itemIdentifierData) as? [String: Any] else {
            return nil
        }
        
        guard let itemId = decoder.decodeObject(forKey: Constants.Keychain.itemId) as? String else {
            return nil
        }

        let isLocked = decoder.decodeBool(forKey: Constants.Keychain.isLocked)
        
        let autoLocked = decoder.decodeBool(forKey: Constants.Keychain.autoLocked)
        
        var actions: [IActionModule] = []
        if let actionsDecoded = decoder.decodeObject(forKey: Constants.Keychain.actionList) as? [IActionModule] {
            actions = actionsDecoded
        }
        self.init(itemId: itemId,
                  itemIdentifier: itemIdentifier,
                  itemType: itemType,
                  channel: channel,
                  keychainItemDetails: keychainItemDetails,
                  actionList: actions,
                  isLocked: isLocked,
                  autoLocked: autoLocked)
    }
    
    //TODO: - Check here if isLocked and autoLocked doesn't work for sensitive
    func encode(with coder: NSCoder) {
        
        let itemIdentifierData = NSKeyedArchiver.archivedData(withRootObject: itemIdentifier)
        
        coder.encode(itemId, forKey: Constants.Keychain.itemId)
        coder.encode(itemIdentifierData, forKey: Constants.Keychain.itemIdentifier)
        coder.encode(itemType.rawValue, forKey: Constants.Keychain.itemType)
        coder.encode(channel.rawValue, forKey: Constants.Keychain.channel)
        coder.encode(keychainItemDetails, forKey: Constants.Keychain.keychainItemDetails)
        coder.encode(actionList, forKey: Constants.Keychain.actionList)
        coder.encode(isLocked, forKey: Constants.Keychain.isLocked)
        coder.encode(autoLocked, forKey: Constants.Keychain.autoLocked)
    }
    
    // MARK: - Helpers (to ItemEnvelope)
    func toItemEnvelope() -> ItemEnvelope {
        let itemPrivateData = ItemPrivateData(privateData: [:])
        let itemMetadata = ItemMetadata(channel: channel, actionList: actionList, itemPrivateData: itemPrivateData, isLocked: isLocked, autoLocked: autoLocked)
        
        return ItemEnvelope(identifier: itemIdentifier, itemId: itemId, itemType: itemType, itemMetadata: itemMetadata)
    }
    
    func toItemEnvelopeWithDetails() -> ItemEnvelope {
        let itemPrivateData = ItemPrivateData(privateData: keychainItemDetails.itemPrivateData)
        let itemMetadata = ItemMetadata(channel: channel, actionList: actionList, itemPrivateData: itemPrivateData, isLocked: isLocked, autoLocked: autoLocked)
        
        return ItemEnvelope(identifier: itemIdentifier, itemId: itemId, itemType: itemType, itemMetadata: itemMetadata)
    }
}

