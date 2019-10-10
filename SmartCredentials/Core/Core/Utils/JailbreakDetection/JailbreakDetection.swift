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

import UIKit

public class JailbreakDetection {
    
    // MARK: - Check jailbroken
    /// Checks if the device is jailbroken and it returns a boolean
    ///
    /// - Returns: true if the device is jailbroken, or false if it is not
    public static func isJailbroken() -> Bool {
        if !UIDevice.isSimulator {
            return hasCommonJailbrokenFiles() || doesSandboxViolation()
        }
        
        return false
    }
    
    // MARK: - Private helper methods
    /// Checks for existence of files that are common for jailbroken devices and it returns a boolean
    ///
    /// - Returns: true if there are any dangerous files, or false if no files are found
    private static func hasCommonJailbrokenFiles() -> Bool {
        if FileManager.default.fileExists(atPath: Constants.JailbreakDetection.cydiaAppPath)
            || FileManager.default.fileExists(atPath: Constants.JailbreakDetection.mobileSubstratePath)
            || FileManager.default.fileExists(atPath: Constants.JailbreakDetection.bashPath)
            || FileManager.default.fileExists(atPath: Constants.JailbreakDetection.sshdPath)
            || FileManager.default.fileExists(atPath: Constants.JailbreakDetection.etcAptPath)
            || FileManager.default.fileExists(atPath: Constants.JailbreakDetection.libAptPath) {
            return true
        }
        
        return false
    }
    
    /// Checks for sandbox violation; it tries to write in system directories and it truereturns a boolean
    ///
    /// - Returns: true if it successfully writes to system directories, otherwise it returns false
    private static func doesSandboxViolation() -> Bool {
        let stringToWrite = Constants.JailbreakDetection.testStringToWrite
        do {
            try stringToWrite.write(toFile: Constants.JailbreakDetection.testPriveFilePath, atomically: true, encoding: .utf8)
            return true
        } catch {
            return false
        }
    }
    
}
