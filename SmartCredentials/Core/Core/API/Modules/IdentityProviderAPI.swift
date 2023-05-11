//
//  IdentityProviderAPI.swift
//  Core
//
//  Created by Camelia Ignat on 02.05.2023.
//  Copyright © 2023 Andrei Moldovan. All rights reserved.
//

import Foundation

public typealias IdentityProviderCompletionHandler = (SmartCredentialsAPIResult<Any?>) -> ()

public protocol IdentityProviderAPI {
    /// Returns the operator token
    ///
    /// - Parameters:
    ///   - baseURL:
    ///   - credentials:
    ///   - clientId:
    ///   - scope:
    ///   - universalLink:
    /// - Returns:
    ///   -
    func getOperatorToken(baseURL: String, credentials: String, clientId: String, scope: String, universalLink: String, completionHandler: @escaping IdentityProviderCompletionHandler)
    
    /// Returns the operator token
    ///
    /// - Parameters:
    ///   - appToken:
    ///   - clientId:
    ///   - scope:
    ///   - universalLink:
    /// - Returns:
    ///   -
    func getOperatorToken(appToken: String, clientId: String, scope: String, universalLink: String, completionHandler: @escaping IdentityProviderCompletionHandler)
}
