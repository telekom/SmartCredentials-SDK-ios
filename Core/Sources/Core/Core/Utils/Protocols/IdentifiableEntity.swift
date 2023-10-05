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

import CoreData

/// Protocol for objects that have to be identifiable
public protocol IdentifiableEntity {
}

// MARK: - NSManagedObject
public extension IdentifiableEntity where Self: NSManagedObject {
    /// Returns the entity name of an NSManagedObject instance (the object's class name)
    static var entityName: String {
        return String(describing: self)
    }
}

extension NSManagedObject: IdentifiableEntity {
}

public protocol Nameable {
}

extension Nameable {
    public var className: String {
        get {
            return String(describing: type(of: self))
        }
    }
}

extension NSObject: Nameable {
}
