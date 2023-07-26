//
//  OneClickBusinessClientAPI.swift
//  Core
//
//  Created by Camelia Ignat on 26.07.2023.
//  Copyright © 2023 Camelia Ignat. All rights reserved.
//

import Foundation

public typealias OneClickBusinessClientCompletionHandler = (SmartCredentialsAPIResult<Any?>) -> ()

public protocol OneClickBusinessClientAPI {
    ///
    ///
    /// - Parameters:
    ///   - productIds: The Ids of the desired recommended products
    /// - Returns: completionHandler with SmartCredentialsAPIResult
    ///   -
    @available(*, deprecated)
    func makeRecommendation(productIds: [String], completionHandler: @escaping OneClickBusinessClientCompletionHandler)

    ///
    ///
    ///
    /// - Parameters:
    ///   - userInfo: userInfo received from didReceiveRemoteNotification method
    /// - Returns: -
    ///   -
    func postRecommendationMessage(userInfo: [AnyHashable : Any])

    ///
    ///
    ///
    /// - Parameters:
    ///   - token: new Firebase token
    /// - Returns: -
    ///   -
    func updateFirebaseToken(token: String)
}
