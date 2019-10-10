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

/// Responsible for creating ItemEnvelope objects that are used in SmartCredentialsAPI
public struct ItemEnvelopeFactory {
    
    /// Creates an ItemEnvelope object used in SmartCredentialsAPI
    ///
    /// - Parameters:
    ///   - id: id of the item envelope
    ///   - itemType: type of the item envelope
    ///   - identifier: identifier dictionary (basic information about the item)
    ///   - privateData: private dictionary (private information about the item)
    /// - Returns: ItemEnvelope object
    public static func itemEnvelope(with id: String, type itemType: ItemType, identifier: [String: Any], privateData: [String: Any]) -> ItemEnvelope {
        let itemPrivateData = ItemPrivateData(privateData: privateData)
        let itemMetadata = ItemMetadata(channel: .type1D, actionList: [], itemPrivateData: itemPrivateData, isLocked: false, autoLocked: false)
        
        LoggerProvider.sharedInstance.logger?.log(.objectCreated, message: Constants.Logger.itemEnvelopeObjectCreated,
                                                  className: String(describing: type(of: self)))
        return ItemEnvelope(identifier: identifier, itemId: id, itemType: itemType, itemMetadata: itemMetadata)
    }
    
    /// Creates an ItemEnvelope object used in SmartCredentialsAPI
    ///
    /// - Parameters:
    ///   - id: id of the item envelope
    ///   - itemType: type of the item envelope
    ///   - identifier: identifier dictionary (basic information about the item)
    ///   - privateData: private dictionary (private information about the item)
    ///   - actionList: metadata actionList
    ///   - isLocked: lock status of the item
    ///   - autoLocked: mandatory lock status of the item
    /// - Returns: ItemEnvelope object
    public static func itemEnvelope(with id: String, type itemType: ItemType, identifier: [String: Any], privateData: [String: Any], actionList: [IActionModule], isLocked: Bool, autoLocked: Bool) -> ItemEnvelope {
        let itemPrivateData = ItemPrivateData(privateData: privateData)
        let itemMetadata = ItemMetadata(channel: .type1D, actionList: actionList, itemPrivateData: itemPrivateData, isLocked: isLocked, autoLocked: autoLocked)
        
        LoggerProvider.sharedInstance.logger?.log(.objectCreated, message: Constants.Logger.itemEnvelopeObjectCreated,
                                                  className: String(describing: type(of: self)))
        return ItemEnvelope(identifier: identifier, itemId: id, itemType: itemType, itemMetadata: itemMetadata)
    }
    
    /// Creates an ItemEnvelope object used in SmartCredentialsAPI
    ///
    /// - Parameters:
    ///   - id: id of the item envelope
    ///   - itemType: type of the item envelope
    ///   - identifier: identifier dictionary (basic information about the item)
    ///   - privateData: private dictionary (private information about the item)
    ///   - actionList: metadata actionList
    /// - Returns: ItemEnvelope object
    public static func itemEnvelope(with id: String, type itemType: ItemType, identifier: [String: Any], privateData: [String: Any], actionList: [IActionModule]) -> ItemEnvelope {
        let itemPrivateData = ItemPrivateData(privateData: privateData)
        let itemMetadata = ItemMetadata(channel: .type1D, actionList: actionList, itemPrivateData: itemPrivateData, isLocked: false, autoLocked: false)
        
        LoggerProvider.sharedInstance.logger?.log(.objectCreated, message: Constants.Logger.itemEnvelopeObjectCreated,
                                                  className: String(describing: type(of: self)))
        return ItemEnvelope(identifier: identifier, itemId: id, itemType: itemType, itemMetadata: itemMetadata)
    }
    
    /// Creates an ItemEnvelope object used in SmartCredentialsAPI
    ///
    /// - Parameters:
    ///   - dictionary: dictionary objects containing itemEnvelope data
    /// - Returns: ItemEnvelope object
    public static func itemEnvelope(from dictionary: [String: Any]) -> ItemEnvelope? {

        var iActions: [IActionModule] = []
        guard let id = dictionary[ItemKeys.id] as? String else {
            return nil
        }
        guard let iType = dictionary[ItemKeys.type] as? String else {
            return nil
        }
        guard let itemType = ItemType.toItemType(typeAsString: iType) else {
            return nil
        }
        guard let identifier = dictionary[ItemKeys.identifier] as? [String: Any] else {
            return nil
        }
        guard let metadata = dictionary[ItemKeys.metadata] as? [String: Any] else {
            return nil
        }
        
        if let actions = metadata[ItemKeys.actions] as? [[String: Any]] {
            for action in actions {

                guard let moduleName = action[ItemKeys.ActionKeys.moduleName] as? String else {
                    continue
                }
     
                if let actionClass = NSClassFromString(moduleName) as? IActionModule.Type,
                    let action = actionClass.init(from: action) {
                    iActions.append(action)
                } else {
                    continue
                }
            }
        }

        guard let privateData = metadata[ItemKeys.privateData] as? [String: Any] else {
            return nil
        }
        
        let itemPrivateData = ItemPrivateData(privateData: privateData)
        let itemMetadata = ItemMetadata(channel: .type1D, actionList: iActions, itemPrivateData: itemPrivateData, isLocked: false, autoLocked: false)
        
        let className = String(describing: type(of: self))
        LoggerProvider.sharedInstance.logger?.log(.objectCreated, message: Constants.Logger.itemEnvelopeRestAPIObjectCreated,
                                                  className: className)
        
        return ItemEnvelope(identifier: identifier, itemId: id, itemType: itemType, itemMetadata: itemMetadata)
    }
    
    /// Creates an ItemEnvelope object used in SmartCredentialsAPI
    ///
    /// - Parameters:
    ///   - path: path for the JSON file
    /// - Returns: ItemEnvelope object
    public static func itemEnvelope(fromJSONAt path: URL) -> ItemEnvelope? {
        do {
            let data = try Data(contentsOf: path, options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            
            if let jsonResult = jsonResult as? [String: AnyObject] {
                return itemEnvelope(from: jsonResult)
            }
        } catch {
            return nil
        }
        
        return nil
    }
}

