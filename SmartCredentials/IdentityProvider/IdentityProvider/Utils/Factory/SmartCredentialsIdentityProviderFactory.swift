//
//  SmartCredentialsIdentityProviderFactory.swift
//  IdentityProvider
//
//  Created by Camelia Ignat on 02.05.2023.
//

import Foundation
import Core

public struct SmartCredentialsIdentityProviderFactory {
    
    public static func smartCredentialIdentityProviderAPI(configuration: SmartCredentialsConfiguration) -> IdentityProviderAPI {
        return IdentityProviderController(configuration: configuration)
    }
}
