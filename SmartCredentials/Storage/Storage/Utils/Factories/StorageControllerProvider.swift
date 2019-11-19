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

/// Responsible for creating StorageController depending on item's content type
struct StorageControllerProvider {
    /// Creates StorageController instance and injects corresponding item store based on content type received
    ///
    /// - Parameter contentType: content type (sensitive / nonsenstive)
    /// - Returns: StorageController object
    static func storageController(for contentType: ContentType, userId: String) -> StorageProtocol {

        // Inject concrete item store based on item's content type (sensitive/nonsensitive)
        if contentType == .nonSensitive { // non sensitive storage
            return NonSensitiveStorageController(userId: userId)
        } else if contentType == .sensitive { // sensitive storage
            return SensitiveStorageController(userId: userId)
        }
        
        return MockStorage(userId: userId)
    }
}
