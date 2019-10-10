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

/// Finds and returns an action from a list of actions
public struct ActionSelector {
    
    public init() {}
    
    /// Selects and returns an action from list with a specific id
    /// Note: If there are multiple actions with the same id, the first one will be returned
    ///
    /// - Parameters:
    ///   - actionId: id of the action to be returned
    ///   - actionsList: list of actions
    /// - Returns: action or nil if no action is found
    public func select(with actionId: String, actionsList: [IActionModule]) -> IActionModule? {
        for action in actionsList {
            if action.actionId == actionId {
                return action
            }
        }
        
        return nil
    }
    
    /// Selects and returns a ConfirmationAction from the list
    ///
    /// - Parameter actionList: list of actions
    /// - Returns: action or nil if no action is found
    func selectConfirmationAction(_ actionList: [IActionModule]) -> IActionModule? {
        for action in actionList {
            if action.moduleName == Constants.Actions.confirmationActionModuleName {
                return action
            }
        }

        return nil
    }
}
