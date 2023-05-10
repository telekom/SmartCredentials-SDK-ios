//
//  Requests.swift
//  IdentityProvider
//
//  Created by George Cristian Cuciureanu on 05.05.2023.
//

import Foundation

class Requests{
    let networkManager = NetworkManager()
    
    public func getAccessTokenRequest() {
        let url = URL(string: "https://lbl-partmgmr.superdtaglb.cf/access-token/" + "Odysee-45930b82-5f64-412f-9993-3456c4c61bbc")!
        networkManager.getRequest(url: url ){ result in
            switch result {
            case .success(let data):
                print("Response data: \(data)")
                let accessToken = String(decoding: data, as: UTF8.self)
                self.getBearerTokenRequest(accessToken: accessToken)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    public func getBearerTokenRequest(accessToken: String) {
            
        let url = URL(string: "https://lbl-partmgmr.superdtaglb.cf/bearer-token-hackathon")!
        let requestBody = BearerTokenRequestBody(accessToken: accessToken, bundleId: Bundle.main.bundleIdentifier, packageName: nil, clientId: UserDefaults.standard.string(forKey: "silentPushClientId"))
        do{
            let encoder = JSONEncoder()
            let data = try encoder.encode(requestBody)
            let jsonString = String(data: data, encoding: .utf8)
            networkManager.postRequest(url: url , body: data){ result in
                switch result {
                case .success(let data):
                    let bearerToken = String(decoding: data, as: UTF8.self)
                    UserDefaults.standard.setValue(bearerToken, forKey: "pamBearerToken")
                case .failure(let error):
                    UserDefaults.standard.setValue(nil, forKey: "pamBearerToken")
                    print("Error: \(error)")
                }
            }
        }
        catch{
            UserDefaults.standard.setValue(nil, forKey: "pamBearerToken")
            print(error)}
    }
}

struct BearerTokenRequestBody: Codable {
    let accessToken: String
    let bundleId: String?
    let packageName: String?
    let clientId: String?
}

struct AccessToken: Codable {
    let accessToken: String?
}
