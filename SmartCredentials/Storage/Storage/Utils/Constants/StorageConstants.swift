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

extension Constants {
    
    enum Logger {
        // Error messages
        static let itemFilterError = "Invalid item filter"
        static let saveError = "Save Error"
        static let itemNotFound = "Item not found"
    }
    
    // MARK: - Core Data
    enum CoreData {
        static let libraryBundleIdentifier = "de.telekom.smartcredentials.Storage"
        static let modelResourceName = "CredentialsModel"
        static let modelResourceExtension = "momd"
        static let persistenceStoreName = "\(modelResourceName).sqlite"
    }
    
    // MARK: - Keychain
    enum Keychain {
        static let serviceName = "SwiftKeychainWrapper"
        static let itemIdentifier = "itemIdentifier"
        static let channel = "channel"
        static let keychainItemDetails = "keychainItemDetails"
        static let itemType = "itemType"
        static let itemId = "itemId"
        static let actionList = "actionList"
        static let itemPrivateData = "itemPrivateData"
        static let isLocked = "isLocked"
        static let autoLocked = "autoLocked"
        
        static let oldItemSummaryClassName = "SmartCredentialsLibrary.KeychainItemSummary"
        static let oldItemDetailsClassName = "SmartCredentialsLibrary.KeychainItemDetails"
    }
}

