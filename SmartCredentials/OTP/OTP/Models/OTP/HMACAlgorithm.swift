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

import CommonCrypto

public enum HMACAlgorithm: String {
    case SHA1
    case MD5
    case SHA256
    case SHA384
    case SHA512
    case SHA224
    
    var size: Int {
        switch self {
        case .SHA1:
            return Int(CC_SHA1_DIGEST_LENGTH)
        case .MD5:
            return Int(CC_MD5_DIGEST_LENGTH)
        case .SHA256:
            return Int(CC_SHA256_DIGEST_LENGTH)
        case .SHA384:
            return Int(CC_SHA384_DIGEST_LENGTH)
        case .SHA512:
            return Int(CC_SHA512_DIGEST_LENGTH)
        case .SHA224:
            return Int(CC_SHA224_DIGEST_LENGTH)
        }
    }
    
    func toCCHmacAlgorithm() -> Int {
        switch self {
        case .SHA1:
            return kCCHmacAlgSHA1
        case .MD5:
            return kCCHmacAlgMD5
        case .SHA256:
            return kCCHmacAlgSHA256
        case .SHA384:
            return kCCHmacAlgSHA384
        case .SHA512:
            return kCCHmacAlgSHA512
        case .SHA224:
            return kCCHmacAlgSHA224
        }
    }
}
