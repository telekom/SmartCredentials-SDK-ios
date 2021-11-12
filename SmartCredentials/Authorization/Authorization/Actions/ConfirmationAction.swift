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

import Core

public class ConfirmationAction: IActionModule {
    
    // MARK: - Initializer
    public required init(actionId: String, moduleName: String, data: [String : Any]) {
        super.init(actionId: actionId, moduleName: moduleName, data: data)
    }
 
    public override func execute(with item: ItemEnvelope, completionHandler: @escaping ExecCallCompletionHandler) {
        
        guard let confirmationTypeString = data[UserConfirmationKeys.type] as? String,
            let confirmationType =  ConfirmationType(rawValue: confirmationTypeString) else {
            completionHandler(.failure(error: ConfirmationActionError.confirmationTypeInvalid))
            return
        }
        
        guard let authorizationModule = SmartCredentialsAuthorizationFactory.authorizationModule else {
            completionHandler(.failure(error: SmartCredentialsAPIError.moduleNotInitialized))
            return
        }
        
        switch confirmationType {
        case .osDefault:
            authorizationModule.authorize { result in
                self.handleConfirmation(result, for: item, completionHandler: completionHandler)
            }
        }
    }
    
    private func handleConfirmation(_ result: SmartCredentialsAPIEmptyResult, for item: ItemEnvelope, completionHandler: ExecCallCompletionHandler) {
        switch result {
        case .success:
            var updatedItem = item
            updatedItem.itemMetadata.isLocked = false
            
            completionHandler(.success(result: updatedItem))
        case .failure(let authorizationError):
            switch authorizationError {
            case .authAppCancel:
                completionHandler(.failure(error: ConfirmationActionError.authAppCancel))
            case .authSystemCancel:
                completionHandler(.failure(error: ConfirmationActionError.authSystemCancel))
            case .authUserCancel:
                completionHandler(.failure(error: ConfirmationActionError.authUserCancel))
            default:
                completionHandler(.failure(error: ConfirmationActionError.authFailed))
            }
        @unknown default:
            // Any future cases not recognized by the compiler yet
            break
        }
    }
    
}


enum ConfirmationActionError: Error {
    
    /**
     Error received if the confirmation type is not specified in the action's data
     */
    case confirmationTypeInvalid
    
    /**
    Error received when the application cancels the authorization process
    */
    case authAppCancel
    
    /**
     Error received when the system cancels the authorization process
     */
    case authSystemCancel

    /**
     Error received when the user cancels the authorization process
     */
    case authUserCancel
    
    /**
     Error received in case of an unsuccessful authorization process
     */
    case authFailed

}

public enum ConfirmationType: String {
    case osDefault
}
