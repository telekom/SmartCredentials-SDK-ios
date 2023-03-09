//
//  User.swift
//  AuthenticationDemoApp
//
//  Created by Camelia Ignat on 09.02.2023.
//

import Foundation
import UIKit

struct User {
    var profilePicture: String
    var name: String
    var givenName: String
    var familyName: String
    var email: String
    var emailVerified: Bool
    var locale: String
    
    static func fromJson(_ json: [String: Any]?) -> User {
        if let json = json {
            let imageURL = json["picture"] as? String
            let accountName = json["name"] as? String
            let givenName = json["given_name"] as? String
            let familyName = json["family_name"] as? String
            let email = json["email"] as? String
            let emailVerified = json["email_verified"] as? Bool
            let locale = json["locale"] as? String
            
            
            
            return User(profilePicture: imageURL ?? "", name: accountName ?? "", givenName: givenName ?? "", familyName: familyName ?? "", email: email ?? "", emailVerified: emailVerified ?? false, locale: locale ?? "")
        }
        
        return User(profilePicture: "", name: "", givenName: "", familyName: "", email: "", emailVerified: false, locale: "")
    }
}
