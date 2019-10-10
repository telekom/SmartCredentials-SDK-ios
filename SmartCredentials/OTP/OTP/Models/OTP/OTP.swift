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

import SSCommonCrypto

class OTP {
    
    let algorithm: HMACAlgorithm
    let numberOfDigits: Int
    let secretKey: Data
    var issuer = ""
    var label = ""
    
    init(algorithm: HMACAlgorithm = .SHA1, numberOfDigits: Int = 6, secretKey: Data) {
        self.algorithm = algorithm
        self.numberOfDigits = numberOfDigits
        self.secretKey = secretKey
    }
    
    func code(_ counter: Int64) -> String {
        // Network byte order
        var bigEndianCounter = counter.bigEndian
        
        // Do the HMAC
        var buffer = [UInt8](repeating: 0, count: algorithm.size)
        CCHmac(UInt32(algorithm.toCCHmacAlgorithm()),
               (secretKey as NSData).bytes,
               secretKey.count,
               &bigEndianCounter,
               MemoryLayout.size(ofValue: bigEndianCounter),
               &buffer)
        
        // Unparse UInt32
        let offset = Int(buffer[buffer.count - 1]) & 0x0f;
        let msk = UnsafePointer<UInt8>(buffer).advanced(by: offset).withMemoryRebound(to: UInt32.self, capacity: algorithm.size / 4) {
                $0[0].bigEndian & 0x7fffffff
        }
        
        // Create digits divisor
        var div: UInt32 = 1
        for _ in 0..<numberOfDigits {
            div *= 10
        }
        
        return String(format: String(format: "%%0%hhulu", numberOfDigits), msk % div)
    }
}
