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

public struct ItemEnvelope {
    
    public var identifier: [String: Any]
    public var itemId: String
    public var itemType: ItemType
    public var itemMetadata: ItemMetadata
    
    public init(identifier: [String: Any], itemId: String, itemType: ItemType, itemMetadata: ItemMetadata) {
        self.identifier = identifier
        self.itemId = itemId
        self.itemType = itemType
        self.itemMetadata = itemMetadata
    }
}

// MARK: - JSON Representation
extension ItemEnvelope {
    func toDictionary() -> [String: Any] {

        return [ItemKeys.id: itemId,
                ItemKeys.type: itemType.toString(),
                ItemKeys.identifier: identifier,
                ItemKeys.metadata: itemMetadata.toDictionary()]
    }
}
