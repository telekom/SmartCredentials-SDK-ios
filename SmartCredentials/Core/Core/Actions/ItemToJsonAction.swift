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

import UIKit

public class ItemToJsonAction: IActionModule {

    public var shareChannel: ShareChannel
    
    // MARK: - Initializer
    public required init(actionId: String, moduleName: String, data: [String: Any], shareChannel: ShareChannel) {
        self.shareChannel = shareChannel

        super.init(actionId: actionId, moduleName: moduleName, data: data)
    }
    
    public required init(actionId: String, moduleName: String, data: [String : Any]) {
        self.shareChannel = .none
        super.init(actionId: actionId, moduleName: moduleName, data: data)
    }
    
    // MARK: - Execute
    public override func execute(with item: ItemEnvelope, completionHandler: @escaping ExecCallCompletionHandler) {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: item.toDictionary(), options: [.prettyPrinted]),
            let jsonString = String(data: jsonData, encoding: .ascii) else {
                completionHandler(.failure(error: ItemToJsonActionError.cannotCreateJSON))
                return
        }
        
        switch shareChannel {
        case .none:
            let shareItemResult = ItemToJsonActionResult(jsonRepresentation: jsonString, shareViewController: nil)
            completionHandler(.success(result: shareItemResult))
            break
        case .osDefault:
            let shareViewController = UIActivityViewController(activityItems: [jsonString], applicationActivities: [])
            let shareItemResult = ItemToJsonActionResult(jsonRepresentation: jsonString, shareViewController: shareViewController)
            completionHandler(.success(result: shareItemResult))
            break
        case .copyToClipboard:
            UIPasteboard.general.string = jsonString
            let shareItemResult = ItemToJsonActionResult(jsonRepresentation: jsonString, shareViewController: nil)
            completionHandler(.success(result: shareItemResult))
            break
        }
    }
    
    // MARK: - NSCoding
    required convenience public init?(coder aDecoder: NSCoder) {
        guard let shareChannelValue = aDecoder.decodeObject(forKey: ItemKeys.ActionKeys.shareChannel) as? String else {
            return nil
        }

        guard let shareChannel = ShareChannel(rawValue: shareChannelValue) else {
            return nil
        }
    
        guard let actionId = aDecoder.decodeObject(forKey: ItemKeys.ActionKeys.actionId) as? String else {
            return nil
        }
        
        guard let moduleName = aDecoder.decodeObject(forKey: ItemKeys.ActionKeys.moduleName) as? String else {
            return nil
        }
        
        guard let dataAsBytes = aDecoder.decodeObject(forKey: ItemKeys.ActionKeys.data) as? Data,
            let data = NSKeyedUnarchiver.unarchiveObject(with: dataAsBytes) as? [String: Any] else {
                return nil
        }
        
        self.init(actionId: actionId, moduleName: moduleName, data: data, shareChannel: shareChannel)
    }
    
    override public func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        
        aCoder.encode(shareChannel.rawValue, forKey: ItemKeys.ActionKeys.shareChannel)
    }
    
    // MARK: - JSON Representation
    required convenience init?(from dictionary: [String : Any]) {
        guard let shareChannelValue = dictionary[ItemKeys.ActionKeys.shareChannel] as? String,
            let shareChannel = ShareChannel(rawValue: shareChannelValue) else {
                return nil
        }
        
        guard let actionId = dictionary[ItemKeys.ActionKeys.actionId] as? String else {
            return nil
        }
        guard let moduleName = dictionary[ItemKeys.ActionKeys.moduleName] as? String else {
            return nil
        }
        guard let data = dictionary[ItemKeys.ActionKeys.data] as? [String: Any] else {
            return nil
        }
        
        self.init(actionId: actionId, moduleName: moduleName, data: data, shareChannel: shareChannel)
    }
    
    public override func toDictionary() -> [String : Any] {
        return [ItemKeys.ActionKeys.actionId: actionId,
                ItemKeys.ActionKeys.moduleName: moduleName,
                ItemKeys.ActionKeys.data: data,
                ItemKeys.ActionKeys.shareChannel: shareChannel.rawValue]
    }
}

// MARK: - ShareChannel
public enum ShareChannel: String {
    case none
    case osDefault
    case copyToClipboard
}

public struct ItemToJsonActionResult {
    public let jsonRepresentation: String
    public let shareViewController: UIViewController?
}

enum ItemToJsonActionError: Error {
    /**
     Error received when the item to JSON transformation failed
     */
    case cannotCreateJSON
}
