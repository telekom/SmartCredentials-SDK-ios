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

class ScannerResultFactory {
    static func createScannerResult(for result: MBRecognizerResult) -> ScannerResult {
        if let result = result as? MBAustriaIdFrontRecognizerResult {
            return AustriaIDFrontCardResult(with: result)
        } else if let result = result as? MBAustriaIdBackRecognizerResult {
            return AustriaIDBackCardResult(with: result)
        } else if let result = result as? MBAustriaCombinedRecognizerResult {
            return AustriaIDCombinedCardResult(with: result)
        } else if let result = result as? MBCyprusIdFrontRecognizerResult {
            return CyprusIDFrontCardResult(with: result)
        } else if let result = result as? MBCyprusIdBackRecognizerResult {
            return CyprusIDBackCardResult(with: result)
        } else if let result = result as? MBColombiaIdFrontRecognizerResult {
            return ColombiaIDFrontCardResult(with: result)
        } else if let result = result as? MBColombiaIdBackRecognizerResult {
            return ColombiaIDBackCardResult(with: result)
        } else if let result = result as? MBCroatiaIdFrontRecognizerResult {
            return CroatiaIDFrontCardResult(with: result)
        } else if let result = result as? MBCroatiaIdBackRecognizerResult {
            return CroatiaIDBackCardResult(with: result)
        } else if let result = result as? MBCroatiaCombinedRecognizerResult {
            return CroatiaIDCombinedCardResult(with: result)
        } else if let result = result as? MBCzechiaIdFrontRecognizerResult {
            return CzechIDFrontCardResult(with: result)
        } else if let result = result as? MBCzechiaIdBackRecognizerResult {
            return CzechIDBackCardResult(with: result)
        } else if let result = result as? MBCzechiaCombinedRecognizerResult {
            return CzechIDCombinedCardResult(with: result)
        } else if let result = result as? MBEgyptIdFrontRecognizerResult {
            return EgyptIDFrontCardResult(with: result)
        } else if let result = result as? MBGermanyIdFrontRecognizerResult {
            return GermanyIDFrontCardResult(with: result)
        } else if let result = result as? MBGermanyIdBackRecognizerResult {
            return GermanyIDBackCardResult(with: result)
        } else if let result = result as? MBGermanyCombinedRecognizerResult {
            return GermanyIDCombinedCardResult(with: result)
        } else if let result = result as? MBGermanyOldIdRecognizerResult {
            return GermanyIDOldCardResult(with: result)
        } else if let result = result as? MBHongKongIdFrontRecognizerResult {
            return HongkongIDFrontCardResult(with: result)
        } else if let result = result as? MBMalaysiaIkadFrontRecognizerResult {
            return IkadIDFrontCardResult(with: result)
        } else if let result = result as? MBIndonesiaIdFrontRecognizerResult {
            return IndonesiaIDFrontCardResult(with: result)
        } else if let result = result as? MBJordanIdFrontRecognizerResult {
            return JordanIDFrontCardResult(with: result)
        } else if let result = result as? MBJordanIdBackRecognizerResult {
            return JordanIDBackCardResult(with: result)
        } else if let result = result as? MBJordanCombinedRecognizerResult {
            return JordanIDCombinedCardResult(with: result)
        } else if let result = result as? MBKuwaitIdFrontRecognizerResult {
            return KuwaitIDFrontCardResult(with: result)
        } else if let result = result as? MBKuwaitIdBackRecognizerResult {
            return KuwaitIDBackCardResult(with: result)
        } else if let result = result as? MBMalaysiaMyTenteraFrontRecognizerResult {
            return MalaysiaMyTenteraIDFrontCardResult(with: result)
        } else if let result = result as? MBMoroccoIdFrontRecognizerResult {
            return MoroccoIDFrontCardResult(with: result)
        } else if let result = result as? MBMoroccoIdBackRecognizerResult {
            return MoroccoIDBackCardResult(with: result)
        } else if let result = result as? MBMrtdRecognizerResult {
            return MrtdCardResult(with: result)
        } else if let result = result as? MBMrtdCombinedRecognizerResult {
            return MrtdCombinedCardResult(with: result)
        } else if let result = result as? MBMalaysiaMyKadFrontRecognizerResult {
            return MyKadIdFrontCardResult(with: result)
        } else if let result = result as? MBMalaysiaMyKadBackRecognizerResult {
            return MyKadIDBackCardResult(with: result)
        } else if let result = result as? MBPolandIdFrontRecognizerResult {
            return PolandIDFrontCardResult(with: result)
        } else if let result = result as? MBPolandIdBackRecognizerResult {
            return PolandIDBackCardResult(with: result)
        } else if let result = result as? MBPolandCombinedRecognizerResult {
            return PolandIDCombinedCardResult(with: result)
        } else if let result = result as? MBRomaniaIdFrontRecognizerResult {
            return RomaniaIDFrontCardResult(with: result)
        } else if let result = result as? MBSerbiaIdFrontRecognizerResult {
            return SerbiaIDFrontCardResult(with: result)
        } else if let result = result as? MBSerbiaIdBackRecognizerResult {
            return SerbiaIDBackCardResult(with: result)
        } else if let result = result as? MBSerbiaCombinedRecognizerResult {
            return SerbiaIDCombinedCardResult(with: result)
        } else if let result = result as? MBSingaporeIdFrontRecognizerResult {
            return SingaporeIDFrontCardResult(with: result)
        } else if let result = result as? MBSingaporeIdBackRecognizerResult {
            return SingaporeIDBackCardResult(with: result)
        } else if let result = result as? MBSingaporeCombinedRecognizerResult {
            return SingaporeIDCombinedCardResult(with: result)
        } else if let result = result as? MBSlovakiaIdFrontRecognizerResult {
            return SlovakiaIDFrontCardResult(with: result)
        } else if let result = result as? MBSlovakiaIdBackRecognizerResult {
            return SlovakiaIDBackCardResult(with: result)
        } else if let result = result as? MBSlovakiaCombinedRecognizerResult {
            return SlovakiaIDCombinedCardResult(with: result)
        } else if let result = result as? MBSloveniaIdFrontRecognizerResult {
            return SloveniaIDFrontCardResult(with: result)
        } else if let result = result as? MBSloveniaIdBackRecognizerResult {
            return SloveniaIDBackCardResult(with: result)
        } else if let result = result as? MBSloveniaCombinedRecognizerResult {
            return SloveniaIDCombinedCardResult(with: result)
        } else if let result = result as? MBSwitzerlandIdFrontRecognizerResult {
            return SwitzerlandIDFrontCardResult(with: result)
        } else if let result = result as? MBSwitzerlandIdBackRecognizerResult {
            return SwitzerlandIDBackCardResult(with: result)
        } else if let result = result as? MBUnitedArabEmiratesIdFrontRecognizerResult {
            return UnitedArabEmiratesIDFrontCardResult(with: result)
        } else if let result = result as? MBUnitedArabEmiratesIdBackRecognizerResult {
            return UnitedArabEmiratesIDBackCardResult(with: result)
        }
        
        if let result = result as? MBPaymentCardFrontRecognizerResult {
            return PaymentCardFrontResult(with: result)
        } else if let result = result as? MBPaymentCardBackRecognizerResult {
            return PaymentCardBackResult(with: result)
        } else if let result = result as? MBPaymentCardCombinedRecognizerResult {
            return PaymentCardCombinedResult(with: result)
        } else if let result = result as? MBElitePaymentCardFrontRecognizerResult {
            return ElitePaymentCardFrontResult(with: result)
        } else if let result = result as? MBElitePaymentCardBackRecognizerResult {
            return ElitePaymentCardBackResult(with: result)
        } else if let result = result as? MBElitePaymentCardCombinedRecognizerResult {
            return ElitePaymentCardCombinedResult(with: result)
        }
        
        return IDCardResult()
    }
}

