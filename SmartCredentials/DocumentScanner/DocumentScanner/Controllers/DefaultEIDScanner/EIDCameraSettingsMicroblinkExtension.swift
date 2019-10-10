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

import MicroBlink
import Core

extension CameraPreset {
    
    /// Converts CameraPreset enum value to MBCameraPreset enum from Microblink
    ///
    /// - Returns: MBCameraPreset corresponding value
    func mbCameraPreset() -> MBCameraPreset {
        switch self {
        case .video480p:
            return .preset480p
        case .video720p:
            return .preset720p
        case .optimal:
            return .presetOptimal
        case .max:
            return .presetMax
        case .photo:
            return .presetPhoto
        }
    }
}

extension CameraType {
    
    /// Converts CameraType enum value to MBCameraType enum from Microblink
    ///
    /// - Returns: MBCameraType corresponding value
    func mbCameraType() -> MBCameraType {
        switch self {
        case .back:
            return .back
        case .front:
            return .front
        }
    }
}
