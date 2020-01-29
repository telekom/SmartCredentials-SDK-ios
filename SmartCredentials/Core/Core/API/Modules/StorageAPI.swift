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

public protocol StorageAPI {
    
    /// Retrieves item's summary info based on the filtering information provided by itemFilter
    ///
    /// - Parameter itemFilter: used for getting item's summary by using item id and content type
    /// - Returns: Generic enum; success - ItemEnvelope object; failure - SmartCredentialsAPIError (enum)
    func getItemSummary(for itemFilter: ItemFilter) -> SmartCredentialsAPIResult<ItemEnvelope>
    
    /// Retrieves items's detailed info (summary and private info) based on the filtering information provided by itemFilter
    ///
    /// - Parameter itemFilter: used for getting item's details by using item id and content type
    /// - Returns: Generic enum; success - ItemEnvelope object; failure - SmartCredentialsAPIError (enum)
    func getItemDetails(for itemFilter: ItemFilter) -> SmartCredentialsAPIResult<ItemEnvelope>
    
    /// Retrieves all items based on the filtering information provided by itemFilter
    ///
    /// - Parameter itemFilter: used for getting all items with the same content type
    /// - Returns: Generic enum; success - list of ItemEnvelope objects; failure - SmartCredentialsAPIError (enum)
    func getAllItems(for itemFilter: ItemFilter) -> SmartCredentialsAPIResult<[ItemEnvelope]>
    
    /// Retrieves persistent data reference object for a sensitive item/generic password.
    /// - Note: This method is available only for items stored as sensitive.
    ///
    /// If the item with the id specified in the itemFilter is not a sensitive item, this method will return an appropriate error.
    ///
    /// - Parameter itemFilter: used for getting item's details by using item id
    /// - Returns: Generic enum; success - password reference data object; failure - SmartCredentialsAPIError (enum)
    func getPasswordReference(for itemFilter: ItemFilter) -> SmartCredentialsAPIResult<Data>
    
    /// Saves the item to the sensitive/nonsensitive repository based on itemContext object received
    ///
    /// - Parameters:
    ///   - item: item to be saved
    ///   - itemContext: context of the item to be saved (encapsulates item's content type)
    /// - Returns: Enum; success - void; failure - SmartCredentialsAPIError (enum)
    func put(_ item: ItemEnvelope, with itemContext: ItemContext) -> SmartCredentialsAPIEmptyResult
    
    /// Saves a generic password (String) to the sensitive repository
    ///
    /// - Parameters:
    ///   - genericPassword: string to be saved into the sensitive repository as Generic Password
    ///   - id: id of the genericPassword to be saved
    /// - Returns: Enum; success - void; failure - SmartCredentialsAPIError (enum)
    func put(_ genericPassword: String, with id: String, sensitiveItemAccessibility: KeychainItemAccessibility) -> SmartCredentialsAPIEmptyResult
    
    /// Updates the item stored in sensitive/nonsensitive repository
    ///
    /// - Parameters:
    ///   - item: item to be updated
    ///   - itemContext: context of the item to be updated (encapsulates item's content type)
    /// - Returns: Enum; success - void; failure - SmartCredentialsAPIError (enum)
    func update(_ item: ItemEnvelope, with itemContext: ItemContext) -> SmartCredentialsAPIEmptyResult
    
    /// Removes the item from sensitive/nonsenstive repository based on filtering information provided by itemFilter
    ///
    /// - Parameter itemFilter: used for removing item from repository using item id and content type
    /// - Returns: Enum; success - void; failure - SmartCredentialsAPIError (enum)
    func removeItem(for itemFilter: ItemFilter) -> SmartCredentialsAPIEmptyResult
    
    /// Removes all items based on the filtering information provided by itemFilter
    ///
    /// - Parameter itemFilter: used for removing all items with the same content type
    /// - Returns: Enum; success - void; failure - SmartCredentialsAPIError (enum)
    func removeAllItems(for itemFilter: ItemFilter) -> SmartCredentialsAPIEmptyResult
}
