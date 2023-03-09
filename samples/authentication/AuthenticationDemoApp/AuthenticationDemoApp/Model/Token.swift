//
//  Token.swift
//  AuthenticationDemoApp
//
//  Created by Camelia Ignat on 18.01.2023.
//

import Foundation

enum TokenType: String {
    case accessToken = "Access token"
    case idToken = "ID token"
    case refreshToken = "Refresh token"
}

struct Token {
    var name: TokenType
    var description: String?
    var expirationDate: String?
//    var type: String?
    
    static func getTokensFromAuthService() -> [Token] {
        let expirationDate = AuthenticationManager.shared.googleAuthService?.authState.getAccessTokenExpirationDate()?.formatted(date: .abbreviated, time: .complete)
        return [Token(name: .accessToken, description: AuthenticationManager.shared.googleAuthService?.authState.getAccessToken(), expirationDate: expirationDate),
                Token(name: .idToken, description: Token.decode(jwtToken: AuthenticationManager.shared.googleAuthService?.authState.getIDToken() ?? "").description),
                Token(name: .refreshToken, description: AuthenticationManager.shared.googleAuthService?.authState.getRefreshToken())]
    }
    
    private static func decode(jwtToken jwt: String) -> [String: Any] {
        let segments = jwt.components(separatedBy: ".")
        return decodeJWTPart(segments[1]) ?? [:]
    }
    
    private static func decodeJWTPart(_ value: String) -> [String: Any]? {
        guard let bodyData = base64UrlDecode(value),
              let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
            return nil
        }
        
        return payload
    }
    
    private static func base64UrlDecode(_ value: String) -> Data? {
        var base64 = value
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
        let requiredLength = 4 * ceil(length / 4.0)
        let paddingLength = requiredLength - length
        if paddingLength > 0 {
            let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
            base64 = base64 + padding
        }
        return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
    }
}
