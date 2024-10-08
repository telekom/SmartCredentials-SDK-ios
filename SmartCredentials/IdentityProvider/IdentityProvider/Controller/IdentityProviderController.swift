//
//  IdentityProviderController.swift
//  IdentityProvider
//
//  Created by Camelia Ignat on 02.05.2023.
//

import Foundation
import Core

class IdentityProviderController {
    var configuration: SmartCredentialsConfiguration
    let requests = Requests()
    private static var completionHandler: Core.IdentityProviderCompletionHandler!
    
    init(configuration: SmartCredentialsConfiguration) {
        self.configuration = configuration
        DispatchQueue.main.async {
            self.swizzleContinueUserActivity()
        }
    }
    
    // MARK: - Jailbreak Check
    private func isJailbroken() -> Bool {
        if configuration.jailbreakCheckEnabled {
            return JailbreakDetection.isJailbroken()
        }
        return false
    }
}

extension IdentityProviderController: IdentityProviderAPI {
    func getOperatorToken(baseURL: String, credentials: String, clientId: String, scope: String, universalLink: String, completionHandler: @escaping Core.IdentityProviderCompletionHandler) {
        if !isJailbroken() {
            IdentityProviderController.completionHandler = completionHandler
            requests.getAccessToken(url: baseURL, credentials: credentials) { [weak self] result in
                switch result {
                case .success(let accessToken):
                    self?.requests.getBearerToken(accessToken: accessToken, clientId: clientId, scope: scope) { result in
                        switch result {
                        case .success(let bearerToken):
                            self?.getOperatorTokenFromSmartAgent(bearerToken: bearerToken, clientId: clientId, scope: scope, universalLink: universalLink)
                        case .failure(_):
                            completionHandler(.failure(error: .bearerTokenCouldNotBeRetrieved))
                        }
                    }
                case .failure(_):
                    completionHandler(.failure(error: .accessTokenCouldNotBeRetrieved))
                }
            }
        }
    }
    
    func getOperatorToken(appToken: String, clientId: String, scope: String, universalLink: String, completionHandler: @escaping Core.IdentityProviderCompletionHandler) {
        if !isJailbroken() {
            IdentityProviderController.completionHandler = completionHandler
            getOperatorTokenFromSmartAgent(bearerToken: appToken, clientId: clientId, scope: scope, universalLink: universalLink)
        }
    }
    
    private func getOperatorTokenFromSmartAgent(bearerToken: String, clientId: String, scope: String, universalLink: String) {
        DispatchQueue.main.async {
            if let link = URL(string: Endpoints.carrierAgentUL.url)?
                .appending(OperatorTokenURLComponents.bearerToken.rawValue, value: bearerToken)
                .appending(OperatorTokenURLComponents.bundleId.rawValue, value: Bundle.main.bundleIdentifier!)
                .appending(OperatorTokenURLComponents.clientId.rawValue, value: clientId)
                .appending(OperatorTokenURLComponents.scope.rawValue, value: scope)
                .appending(OperatorTokenURLComponents.universalLink.rawValue, value: universalLink) {
                UIApplication.shared.open(link)
            }
        }
    }
}

// MARK: - Method swizzling on Scene Delegate
extension IdentityProviderController {
    @objc
    dynamic func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        if userActivity.activityType == "NSUserActivityTypeBrowsingWeb" {
            let url = userActivity.webpageURL ?? URL(fileURLWithPath: "")
            let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: false)
            
            for i in 0..<(urlComponents?.queryItems?.count ?? 0) {
                if urlComponents?.queryItems?[i].name == "transactionToken" {
                    if urlComponents?.queryItems?[i].value == "" {
                        IdentityProviderController.completionHandler(.failure(error: .invalidOperatorToken))
                    } else {
                        if urlComponents?.queryItems?[i].value == "cancel" {
                            IdentityProviderController.completionHandler(.failure(error: .operatorTokenUserCancellation))
                            return
                        }
                        let dictionary = NSDictionary(object: urlComponents?.queryItems?[i].value as Any, forKey: "transactionToken" as NSCopying)
                        let transactionToken = dictionary["transactionToken"]
                        IdentityProviderController.completionHandler(.success(result: transactionToken))
                    }
                }
            }
        }
    }

    private func swizzleContinueUserActivity() {
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate
        let sceneDelegateClass: AnyClass? = object_getClass(sceneDelegate)

        let originalSelector = #selector(UIWindowSceneDelegate.scene(_:continue:))
        let swizzledSelector = #selector(IdentityProviderController.self.scene(_:continue:))

        if let originalMethod = class_getInstanceMethod(sceneDelegateClass, originalSelector),
           let swizzledMethod = class_getInstanceMethod(IdentityProviderController.self, swizzledSelector) {
            
            let didAddMethod = class_addMethod(sceneDelegateClass,
                                               originalSelector,
                                               method_getImplementation(swizzledMethod),
                                               method_getTypeEncoding(swizzledMethod))
            
            if didAddMethod {
                class_replaceMethod(sceneDelegateClass,
                                    swizzledSelector,
                                    method_getImplementation(originalMethod),
                                    method_getTypeEncoding(originalMethod))
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
        } else if let swizzledMethod = class_getInstanceMethod(IdentityProviderController.self, swizzledSelector) {
            class_addMethod(sceneDelegateClass,
                            originalSelector,
                            method_getImplementation(swizzledMethod),
                            method_getTypeEncoding(swizzledMethod))
        }
    }
}
