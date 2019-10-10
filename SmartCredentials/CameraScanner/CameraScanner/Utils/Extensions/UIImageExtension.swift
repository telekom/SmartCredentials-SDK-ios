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

import AVFoundation
import UIKit

extension UIImage {
    convenience init?(from sampleBuffer: CMSampleBuffer) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return nil
        }
        
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()
        
        let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
        
        guard let image = context.createCGImage(ciImage, from: imageRect) else {
            return nil
        }
        
        self.init(cgImage: image, scale: UIScreen.main.scale, orientation: .left)
    }
    
    func blackAndWhite() -> UIImage {
        let beginImage = CIImage(cgImage: cgImage!)
        let blackAndWhite = CIFilter(name: "CIColorControls", parameters: [kCIInputImageKey: beginImage,
                                                                           kCIInputBrightnessKey: 0,
                                                                           kCIInputContrastKey: 1.1,
                                                                           kCIInputSaturationKey: 0])?.outputImage
        let output = CIFilter(name: "CIExposureAdjust", parameters: [kCIInputImageKey: blackAndWhite!,
                                                                     kCIInputEVKey: 0.7])?.outputImage
        
        let context = CIContext()
        let cgiImage = context.createCGImage(output!, from: (output?.extent)!)
        let newImage = UIImage(cgImage: cgiImage!, scale: 0, orientation: imageOrientation)
        
        return newImage
    }
}
