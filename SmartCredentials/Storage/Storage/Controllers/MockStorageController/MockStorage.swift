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

struct MockStorage: StorageProtocol {
    var userId: String
    
    func add(_ item: ItemEnvelope) -> SmartCredentialsAPIEmptyResult {
        return .failure(error: .moduleNotAvailable)
    }
    
    func add(_ genericPassword: String, with id: String) -> SmartCredentialsAPIEmptyResult {
        return .failure(error: .moduleNotAvailable)
    }
    
    func update(_ item: ItemEnvelope) -> SmartCredentialsAPIEmptyResult {
        return .failure(error: .moduleNotAvailable)
    }
    
    func getSummary(for itemFilter: ItemFilter) -> SmartCredentialsAPIResult<ItemEnvelope> {
        return .failure(error: .moduleNotAvailable)
    }
    
    func getDetails(for itemFilter: ItemFilter) -> SmartCredentialsAPIResult<ItemEnvelope> {
        return .failure(error: .moduleNotAvailable)
    }
    
    func getAllItems() -> SmartCredentialsAPIResult<[ItemEnvelope]> {
        return .failure(error: .moduleNotAvailable)
    }
    
    func getPasswordReference(for itemFilter: ItemFilter) -> SmartCredentialsAPIResult<Data> {
        return .failure(error: .moduleNotAvailable)
    }
    
    func removeItem(for itemFilter: ItemFilter) -> SmartCredentialsAPIEmptyResult {
        return .failure(error: .moduleNotAvailable)
    }
    
    func removeAllItems() -> SmartCredentialsAPIEmptyResult {
        return .failure(error: .moduleNotAvailable)
    }
}
