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

/// Responsible for creating different ItemFilter objects that are used in SmartCredentialsAPI for querying items
public struct ItemFilterFactory {
    
    // MARK: - Voucher & Tokens
    /// Creates an ItemFilter object used for getting summary or detailed information for a specific voucher/token
    ///
    /// - Parameters:
    ///   - itemId: voucher's/token's id
    ///   - contentType: content type of the item (sensitive / nonsensitive); sensitive by default;
    ///   - itemAccessibility: attribute used in Keychain for sensitive items only
    /// - Returns: ItemFilter object
    public static func itemFilter(with itemId: String,
                                  contentType: ContentType = .sensitive,
                                  itemAccessibility: KeychainItemAccessibility = .whenUnlockedThisDeviceOnly) -> ItemFilter {
        LoggerProvider.sharedInstance.logger?.log(.objectCreated, message: Constants.Logger.itemFilterObjectCreated, className: String(describing: type(of: self)))
        return ItemFilter(itemId: itemId, contentType: contentType, sensitiveItemAccessibility: itemAccessibility)
    }
    
    /// Creates an ItemFilter object used for getting all tokens / vouchers
    /// - Parameters:
    ///   - contentType: content type of the items (sensitive / nonsensitive); sensitive by default
    ///   - itemAccessibility: attribute used in Keychain for sensitive items only
    /// - Returns: ItemFilter object
    public static func itemFilter(with contentType: ContentType = .sensitive,
                                  itemAccessibility: KeychainItemAccessibility = .whenUnlockedThisDeviceOnly) -> ItemFilter {
        LoggerProvider.sharedInstance.logger?.log(.objectCreated, message: Constants.Logger.itemFilterObjectCreated, className: String(describing: type(of: self)))
        return ItemFilter(itemId: nil, contentType: contentType, sensitiveItemAccessibility: itemAccessibility)
    }
}
