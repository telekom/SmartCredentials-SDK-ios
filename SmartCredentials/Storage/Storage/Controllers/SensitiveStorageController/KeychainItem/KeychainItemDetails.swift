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

@objc class KeychainItemDetails: NSObject, NSCoding {
    
    var itemPrivateData: [String: Any] = [:]
    
    // MARK: - Initialization
    init(itemPrivateData: [String: Any]) {
        self.itemPrivateData = itemPrivateData
    }
    
    // MARK: - NSCoding Protocol
    required convenience init?(coder decoder: NSCoder) {
        guard let privateData = decoder.decodeObject(forKey: Constants.Keychain.itemPrivateData) as? Data else {
            return nil
        }
        
        guard let itemPrivateData = NSKeyedUnarchiver.unarchiveObject(with: privateData) as? [String: Any] else {
            return nil
        }
        
        self.init(itemPrivateData: itemPrivateData)
    }
    
    func encode(with coder: NSCoder) {
        let privateData = NSKeyedArchiver.archivedData(withRootObject: itemPrivateData)
        coder.encode(privateData, forKey: Constants.Keychain.itemPrivateData)
    }
}
