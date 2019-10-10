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

protocol StorageProtocol {
    
    var userId: String { get set }
    
    func add(_ item: ItemEnvelope) -> SmartCredentialsAPIEmptyResult
    func add(_ genericPassword: String, with id: String) -> SmartCredentialsAPIEmptyResult
    func update(_ item: ItemEnvelope) -> SmartCredentialsAPIEmptyResult
    func getSummary(for itemFilter: ItemFilter) -> SmartCredentialsAPIResult<ItemEnvelope>
    func getDetails(for itemFilter: ItemFilter) -> SmartCredentialsAPIResult<ItemEnvelope>
    func getAllItems() -> SmartCredentialsAPIResult<[ItemEnvelope]>
    func getPasswordReference(for itemFilter: ItemFilter) -> SmartCredentialsAPIResult<Data>
    func removeItem(for itemFilter: ItemFilter) -> SmartCredentialsAPIEmptyResult
    func removeAllItems() -> SmartCredentialsAPIEmptyResult
    
}
