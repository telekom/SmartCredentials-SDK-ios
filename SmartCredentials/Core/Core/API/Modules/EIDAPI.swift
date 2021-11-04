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
import UIKit

public protocol EIDAPI {
    /// Initialize the communication with AusweisApp
    ///
    func initialize(completionHandler: @escaping (Message?, Error?) -> ())

    /// Shuts down the communication with Ausweis app
    /// Is required everytime a legitimation is done
    func shutdown()

    /// Returns true if a communication with Ausweis app is in progress
    func isRunning() -> Bool
    
    /// Returns information about all connected readers.
    ///
    /// - Parameters:
    ///   - command: the command  that needs to be send
    ///   - completionHandler: callback with error
    func sendCommand(_ command: Command, completionHandler: @escaping (Error?) -> ())
    
    /// Sets the callback for messages received from Ausweis app
    ///
    func setMessageReceiverCallback(completionHandler: @escaping (Message?, Error?) -> ())
}
