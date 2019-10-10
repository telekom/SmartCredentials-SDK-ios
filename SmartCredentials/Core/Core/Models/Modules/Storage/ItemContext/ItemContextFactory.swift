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

/// Responsible for creating different ItemContext objects that are used in SmartCredentialsAPI for adding new items
public struct ItemContextFactory {
    
    /// Creates an ItemContext object used for adding new items
    ///
    /// - Parameter contentType: content type of the item (sensitive / nonsensitive); sensitive by default
    /// - Returns: ItemContext object
    public static func itemContext(with contentType: ContentType = .sensitive) -> ItemContext {
        LoggerProvider.sharedInstance.logger?.log(.objectCreated, message: Constants.Logger.itemContextObjectCreated, className: String(describing: type(of: self)))
        return ItemContext(contentType: contentType)
    }
}
