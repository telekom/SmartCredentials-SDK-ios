//
//  SmartCredentialsOCBClientConfiguration.swift
//  Core
//
//  Created by Camelia Ignat on 26.07.2023.
//  Copyright © 2023 Camelia Ignat. All rights reserved.
//

import Foundation
import UIKit

public struct SmartCredentialsOCBClientConfiguration {
    public var firebaseId: String
    public var serverKey: String
    public var serverURL: String
    public var credentials: String
    public var clientAppName: String
    public var clientLogo: UIImage
    public var universalLink: String
    public var jailbreakCheckEnabled = true
        
    public init(firebaseId: String, serverKey: String, serverURL: String, credentials: String, clientAppName: String, clientLogo: UIImage, universalLink: String, logger: LogAPI? = nil, jailbreakCheckEnabled: Bool = true) {
        LoggerProvider.sharedInstance.logger = logger
        
        self.firebaseId = firebaseId
        self.serverKey = serverKey
        self.serverURL = serverURL
        self.credentials = credentials
        self.clientAppName = clientAppName
        self.clientLogo = clientLogo
        self.universalLink = universalLink
        self.jailbreakCheckEnabled = jailbreakCheckEnabled
    }
}
