//
//  Endpoints.swift
//  IdentityProvider
//
//  Created by Camelia Ignat on 11.05.2023.
//

import Foundation

enum Endpoints: String {
    case accessToken
    case bearerToken
    case carrierAgentUL
    
    private var baseUrl: String {
        return "https://lbl-partmgmr.superdtaglb.cf"
    }
    
    var url: String {
        switch self {
        case .accessToken:
            return baseUrl + "/access-token"
        case .bearerToken:
            return baseUrl + "/bearer-token-hackathon"
        case .carrierAgentUL:
            return "https://carrier-agent-ul-server.onrender.com"
        }
    }
}
