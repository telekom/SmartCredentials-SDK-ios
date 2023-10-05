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

import CoreGraphics

/// Used for configuring different settings on camera object used in EID scanning
public struct EIDCameraSettings {
    /**
     * Scanning region
     * Defines a portion of the screen in which the scanning will be performed.
     * Given as a CGRect with unit coordinating system:
     *
     * @example CGRectMake(0.2f, 0.5f, 0.4f, 0.3f) defines a portion of the screen which starts at
     *   20% from the left border
     *   50% from the top
     *   covers 40% of screen width
     *   and 30% of screen heeight
     */
    public var scanningRegion: CGRect
    
    /**
     * If true, camera will display Status bar.
     * Usually, if camera is displayed inside Navigation View Controler, this is reasonable to set to true.
     *
     * Default: false.
     */
    public var showStatusBar: Bool = false
    
    /**
     * Camera preset. With this property you can set the resolution of the camera
     *
     * Default: optimal
     */
    public var cameraPreset: CameraPreset = .optimal
    
    /**
     * Camera type. You can choose between front and back facing.
     *
     * Default: back
     */
    public var cameraType: CameraType = .back
    
    
    public init(scanningRegion: CGRect) {
        self.scanningRegion = scanningRegion
    }
}

public enum CameraPreset {
    /** 480p video will always be used */
    case video480p
    
    /** 720p video will always be used */
    case video720p
    
    /** The library will calculate optimal resolution based on the use case and device used */
    case optimal
    
    /** Device's maximal video resolution will be used. */
    case max

    /** Device's photo preview resolution will be used */
    case photo
}

public enum CameraType {
    /** Back facing camera */
    case back
    
    /** Front facing camera */
    case front
}
