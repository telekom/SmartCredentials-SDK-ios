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

public struct ItemMetadata {
    
    public var channel: Channel
    public var itemPrivateData: ItemPrivateData
    public var actionList: [IActionModule]
    public var isLocked: Bool
    public var autoLocked: Bool
    
    public init(channel: Channel, actionList: [IActionModule], itemPrivateData: ItemPrivateData, isLocked: Bool, autoLocked: Bool) {
        self.channel = channel
        self.actionList = actionList
        self.itemPrivateData = itemPrivateData
        self.isLocked = isLocked
        self.autoLocked = autoLocked
    }
}

// MARK: - JSON Representation
extension ItemMetadata {
    func toDictionary() -> [String: Any] {
        return [ItemKeys.privateData: itemPrivateData.toDictionary(),
                ItemKeys.actions: actionList.map({ action -> [String: Any] in
                    return action.toDictionary()
                })]
    }
}
