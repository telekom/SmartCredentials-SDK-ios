//
//  EIDController.swift
//  EID
//
//  Created by Camelia Ignat on 18.10.2021.
//

import Foundation
import Core

class EIDController {
    var configuration: SmartCredentialsConfiguration
    
    init(configuration: SmartCredentialsConfiguration) {
        self.configuration = configuration
    }
    
    // MARK: - Jailbreak Check
    private func isJailbroken() -> Bool {
        if configuration.jailbreakCheckEnabled {
            return JailbreakDetection.isJailbroken()
        }
        return false
    }
}

extension EIDController: EIDAPI {
    
}
