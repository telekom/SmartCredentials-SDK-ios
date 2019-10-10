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

// TODO: need to investigate if it's possible to remove public from Constants.Logger

public enum Constants {

    public enum Logger {
        // Item Filter Factory
        static let itemFilterObjectCreated = "ItemFilter object created"
        // Item Context Factory
        static let itemContextObjectCreated = "ItemContext object created"
        // Item Envelope Factory
        public static let itemEnvelopeObjectCreated = "ItemEnvelope object created"
        public static let itemEnvelopeRestAPIObjectCreated = "ItemEnvelope for REST API call object created"
        // Jailbreak
        public static let jailbreakError = "Device is jailbroken"
    }
    
    // MARK: - Jailbreak Detection
    enum JailbreakDetection {
        // Paths for files that are common for jailbroken devices
        static let cydiaAppPath = "/Applications/Cydia.app"
        static let mobileSubstratePath = "/Library/MobileSubstrate/MobileSubstrate.dylib"
        static let bashPath = "/bin/bash"
        static let sshdPath = "/usr/sbin/sshd"
        static let etcAptPath = "/etc/apt"
        static let libAptPath = "/private/var/lib/apt/"
        static let cydiaPackageURLString = "cydia://package/com.example.package"
        
        // Constants used for checking sandbox violation
        static let testStringToWrite = "Jailbreak Test"
        static let testPriveFilePath = "/private/JailbreakTest.txt"
    }
    
    enum Actions {
        static let confirmationActionModuleName = "Authorization.ConfirmationAction"
    }
}
