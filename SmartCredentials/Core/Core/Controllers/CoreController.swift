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

class CoreController: CoreAPI {
    
    var jailbreakCheckEnabled: Bool
    var userId: String
    let logger = LoggerProvider.sharedInstance.logger

    // MARK: - Initializer
    public init(configuration: SmartCredentialsConfiguration) {
        self.userId = configuration.userId
        self.jailbreakCheckEnabled = configuration.jailbreakCheckEnabled
    }
    
    func isDeviceJailbroken() -> SmartCredentialsAPIResult<Bool> {
        return .success(result: JailbreakDetection.isJailbroken())
    }
    
    func execute(with item: ItemEnvelope, actionId: String, completionHandler: @escaping ExecCallCompletionHandler) {
        guard isJailbroken() == false else {
            logger?.log(.error, message: Constants.Logger.jailbreakError, className: className)
            completionHandler(.failure(error: SmartCredentialsAPIError.jailbreakDetected))
            return
        }

        let actionSelector = ActionSelector()
        
        if let action = actionSelector.select(with: actionId, actionsList: item.itemMetadata.actionList) {
            
            if action.moduleName == Constants.Actions.confirmationActionModuleName {
                // Normal execution of action (ConfirmationAction)
                action.execute(with: item, completionHandler: completionHandler)
            } else {
                // Execution of actions different than ConfirmationAction
                if item.itemMetadata.isLocked || item.itemMetadata.autoLocked {
                    
                    if let confirmationAction = actionSelector.selectConfirmationAction(item.itemMetadata.actionList) {
                        // eeecute confirmation action and if success execute the second action
                        
                        confirmationAction.execute(with: item) { confirmationActionResult in
                            switch confirmationActionResult {
                            case .success(let response):
                                
                                guard let updatedItem = response as? ItemEnvelope else {
                                    completionHandler(.failure(error: SmartCredentialsAPIError.confirmationActionExecution))
                                    return
                                }
                                
                                action.execute(with: updatedItem, completionHandler: completionHandler)
                                
                            case .failure(_):
                                completionHandler(.failure(error: SmartCredentialsAPIError.confirmationActionExecution))
                            }
                        }
                        
                    } else {
                        completionHandler(.failure(error: SmartCredentialsAPIError.actionNotFound))
                    }
                    
                } else {
                    // Item is unlocked
                    // Normal execution of action
                    action.execute(with: item, completionHandler: completionHandler)
                }
            }
            
        } else {
            completionHandler(.failure(error: SmartCredentialsAPIError.actionNotFound))
        }
    }
    
    // MARK: - Jailbreak Check
    private func isJailbroken() -> Bool {
        if jailbreakCheckEnabled {
            return JailbreakDetection.isJailbroken()
        }
        return false
    }
}

extension CoreController: Nameable {
}
