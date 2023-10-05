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

public enum ItemType: Int {
    case voucher
    case token
    case other
    case totp
    case hotp
}

extension ItemType {
    static func toItemType(typeAsString: String) -> ItemType? {
        let type = typeAsString.lowercased()
        switch type {
        case "voucher":
            return ItemType.voucher
        case "token":
            return ItemType.token
        case "other":
            return ItemType.other
        case "totp":
            return ItemType.totp
        case "hotp":
            return ItemType.hotp
        default:
            return nil
        }
    }
    
    func toString() -> String {
        switch self {
        case .voucher:
            return "voucher"
        case .token:
            return "token"
        case .other:
            return "other"
        case .totp:
            return "totp"
        case .hotp:
            return "hotp"
        }
    }
}
