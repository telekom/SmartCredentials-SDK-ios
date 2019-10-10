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

public enum ExecCallAPIResult<T> {
    case success(result: T)
    case failure(error: Error)
}

open class IActionModule: NSObject, NSCoding {
    
    open var actionId: String
    open var moduleName: String
    open var data: [String: Any]
    
    
    // MARK: - Initializer
    required public init(actionId: String, moduleName: String, data: [String: Any]) {
        self.actionId = actionId
        self.moduleName = moduleName
        self.data = data
    }
    
    // MARK: - Execute
    open func execute(with item: ItemEnvelope, completionHandler: @escaping ExecCallCompletionHandler) {
        completionHandler(.success(result: nil))
    }
    
    // MARK: - NSCoding
    required public convenience init?(coder aDecoder: NSCoder) {
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
        
        self.init(actionId: actionId, moduleName: moduleName, data: data)
    }
    
    public func encode(with aCoder: NSCoder) {
        let dataEncoded = NSKeyedArchiver.archivedData(withRootObject: data)
        
        aCoder.encode(actionId, forKey: ItemKeys.ActionKeys.actionId)
        aCoder.encode(moduleName, forKey: ItemKeys.ActionKeys.moduleName)
        aCoder.encode(dataEncoded, forKey: ItemKeys.ActionKeys.data)
    }
    
    // MARK: - JSON Representation
    open func toDictionary() -> [String : Any] {
        return [ItemKeys.ActionKeys.actionId: actionId,
                ItemKeys.ActionKeys.moduleName: moduleName,
                ItemKeys.ActionKeys.data: data]
    }
    
    public required convenience init?(from dictionary: [String: Any]) {
        guard let actionId = dictionary[ItemKeys.ActionKeys.actionId] as? String else {
            return nil
        }
        guard let moduleName = dictionary[ItemKeys.ActionKeys.moduleName] as? String else {
            return nil
        }
        guard let data = dictionary[ItemKeys.ActionKeys.data] as? [String: Any] else {
            return nil
        }

        self.init(actionId: actionId, moduleName: moduleName, data: data)
    }
}
