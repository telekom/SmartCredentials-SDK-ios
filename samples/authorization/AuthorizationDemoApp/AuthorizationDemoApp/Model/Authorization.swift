//
//  Authorization.swift
//  AuthorizationDemoApp
//
//  Created by Camelia Ignat on 16.11.2022.
//

import Foundation
import UIKit

enum Authorization {
    case success
    case failure
    
    var text: String {
        switch self {
        case .success:
            return "Successful authorization."
        case .failure:
            return "Authentication cancelled"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .success:
            return UIImage(systemName: "checkmark.circle")
        case .failure:
            return UIImage(systemName: "exclamationmark.circle")
        }
    }
}
