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

extension ScannerRecognizer {

    /**
     Return recognizer settings
     */
    func recognizerSettings() -> MBRecognizer {
        switch self {
        case .austriaIDFront:
            let recognizer = MBAustriaIdFrontRecognizer()
            recognizer.returnFaceImage = true
            return recognizer
        case .austriaIDBack:
            return MBAustriaIdBackRecognizer()
        case .austriaIDCombined:
            let recognizer = MBAustriaCombinedRecognizer()
            recognizer.returnFaceImage = true
            return recognizer
        case .cyprusIDFront:
            let recognizer = MBCyprusIdFrontRecognizer()
            recognizer.returnFaceImage = true
            return recognizer
        case .cyprusIDBack:
            return MBCyprusIdBackRecognizer()
        case .colombiaIDFront:
            let recognizer = MBColombiaIdFrontRecognizer()
            recognizer.returnFaceImage = true
            return recognizer
        case .colombiaIDBack:
            return MBColombiaIdBackRecognizer()
        case .croatiaIDFront:
            let recognizer = MBCroatiaIdFrontRecognizer()
            recognizer?.returnFaceImage = true
            return recognizer ?? MBCroatiaIdFrontRecognizer()
        case .croatiaIDBack:
            return MBCroatiaIdBackRecognizer()
        case .croatiaIDCombined:
            let recognizer = MBCroatiaCombinedRecognizer()
            recognizer.returnFaceImage = true
            return recognizer
        case .czechIDFront:
            let recognizer = MBCzechiaIdFrontRecognizer()
            recognizer.returnFaceImage = true
            return recognizer
        case .czechIDBack:
            return MBCzechiaIdBackRecognizer()
        case .czechIDCombined:
            let recognizer = MBCzechiaCombinedRecognizer()
            recognizer.returnFaceImage = true
            return recognizer
        case .egyptIDFront:
            let recognizer = MBEgyptIdFrontRecognizer()
            recognizer.returnFaceImage = true
            return recognizer
        case .germanyIDFront:
            let recognizer = MBGermanyIdFrontRecognizer()
            recognizer.returnFaceImage = true
            return recognizer
        case .germanyIDBack:
            return MBGermanyIdBackRecognizer()
        case .germanyIDCombined:
            let recognizer = MBGermanyCombinedRecognizer()
            recognizer.returnFaceImage = true
            return recognizer
        case .germanyIDOld:
            let recognizer = MBGermanyOldIdRecognizer()
            recognizer.returnFaceImage = true
            return recognizer
        case .hongkongIDFront:
            let recognizer = MBHongKongIdFrontRecognizer()
            recognizer.returnFaceImage = true
            return recognizer
        case .ikadIDFront:
            let recognizer = MBMalaysiaIkadFrontRecognizer()
            recognizer.returnFaceImage = true
            return recognizer
        case .indonesiaIDFront:
            let recognizer = MBIndonesiaIdFrontRecognizer()
            recognizer.returnFaceImage = true
            return recognizer
        case .jordanIDFront:
            let recognizer = MBJordanIdFrontRecognizer()
            recognizer.returnFaceImage = true
            return recognizer
        case .jordanIDBack:
            return MBJordanIdBackRecognizer()
        case .jordanIDCombined:
            let recognizer = MBJordanCombinedRecognizer()
            recognizer.returnFaceImage = true
            return recognizer
        case .kuwaitIDFront:
            let recognizer = MBKuwaitIdFrontRecognizer()
            recognizer.returnFaceImage = true
            return recognizer
        case .kuwaitIDBack:
            return MBKuwaitIdBackRecognizer()
        case .mrtd:
            return MBMrtdRecognizer()
        case .mrtdCombined:
            let recognizer = MBMrtdCombinedRecognizer()
            recognizer.returnFaceImage = true
            return recognizer
        case .myKadIDFront:
            let recognizer = MBMalaysiaMyKadFrontRecognizer()
            recognizer.returnFaceImage = true
            return recognizer
        case .myKadIDBack:
            return MBMalaysiaMyKadBackRecognizer()
        case .malaysiaMyTenteraIDFront:
            let recognizer = MBMalaysiaMyTenteraFrontRecognizer()
            recognizer.returnFaceImage = true
            return recognizer
        case .moroccoIDFront:
            let recognizer = MBMoroccoIdFrontRecognizer()
            recognizer.returnFaceImage = true
            return recognizer
        case .moroccoIDBack:
            return MBMoroccoIdBackRecognizer()
        case .polandIDFront:
            let recognizer = MBPolandIdFrontRecognizer()
            recognizer.returnFaceImage = true
            return recognizer
        case .polandIDBack:
            return MBPolandIdBackRecognizer()
        case .polandIDCombined:
            let recognizer = MBPolandCombinedRecognizer()
            recognizer.returnFaceImage = true
            return recognizer
        case .romaniaIDFront:
            let recognizer = MBRomaniaIdFrontRecognizer()
            recognizer.returnFaceImage = true
            return recognizer
        case .serbiaIDFront:
            let recognizer = MBSerbiaIdFrontRecognizer()
            recognizer.returnFaceImage = true
            return recognizer
        case .serbiaIDBack:
            return MBSerbiaIdBackRecognizer()
        case .serbiaIDCombined:
            let recognizer = MBSerbiaCombinedRecognizer()
            recognizer.returnFaceImage = true
            return recognizer
        case .singaporeIDFront:
            let recognizer = MBSingaporeIdFrontRecognizer()
            recognizer.returnFaceImage = true
            return recognizer
        case .singaporeIDBack:
            return MBSingaporeIdBackRecognizer()
        case .singaporeIDCombined:
            let recognizer = MBSingaporeCombinedRecognizer()
            recognizer.returnFaceImage = true
            return recognizer
        case .slovakiaIDFront:
            let recognizer = MBSlovakiaIdFrontRecognizer()
            recognizer.returnFaceImage = true
            return recognizer
        case .slovakiaIDBack:
            return MBSlovakiaIdBackRecognizer()
        case .slovakiaIDCombined:
            let recognizer = MBSlovakiaCombinedRecognizer()
            recognizer.returnFaceImage = true
            return recognizer
        case .sloveniaIDFront:
            let recognizer = MBSloveniaIdFrontRecognizer()
            recognizer.returnFaceImage = true
            return recognizer
        case .sloveniaIDBack:
            return MBSloveniaIdBackRecognizer()
        case .sloveniaIDCombined:
            let recognizer = MBSloveniaCombinedRecognizer()
            recognizer.returnFaceImage = true
            return recognizer
        case .switzerlandIDFront:
            let recognizer = MBSwitzerlandIdFrontRecognizer()
            recognizer.returnFaceImage = true
            return recognizer
        case .switzerlandIDBack:
            return MBSwitzerlandIdBackRecognizer()
        case .unitedArabEmiratesIDFront:
            let recognizer = MBUnitedArabEmiratesIdFrontRecognizer()
            recognizer.returnFaceImage = true
            return recognizer
        case .unitedArabEmiratesIDBack:
            return MBUnitedArabEmiratesIdBackRecognizer()
            
        case .paymentCardFront:
            let recognizer = MBPaymentCardFrontRecognizer()
            recognizer.returnFullDocumentImage = true
            return recognizer
        case .paymentCardBack:
            let recognizer = MBPaymentCardBackRecognizer()
            recognizer.returnFullDocumentImage = true
            return recognizer
        case .paymentCardCombined:
            let recognizer = MBPaymentCardCombinedRecognizer()
            recognizer.returnFullDocumentImage = true
            return recognizer
        case .elitePaymentCardFront:
            let recognizer = MBElitePaymentCardFrontRecognizer()
            recognizer.returnFullDocumentImage = true
            return recognizer
        case .elitePaymentCardBack:
            let recognizer = MBElitePaymentCardBackRecognizer()
            recognizer.returnFullDocumentImage = true
            return recognizer
        case .elitePaymentCardCombined:
            let recognizer = MBElitePaymentCardCombinedRecognizer()
            recognizer.returnFullDocumentImage = true
            return recognizer
        }
    }
}
