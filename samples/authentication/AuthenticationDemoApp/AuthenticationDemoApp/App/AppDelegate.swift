//
//  AppDelegate.swift
//  AuthenticationDemoApp
//
//  Created by Camelia Ignat on 09.01.2023.
//

import UIKit
import Authentication
import AppAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var currentAuthService: AuthServiceProtocol?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let authorizationFlow = self.currentAuthService,
                                     authorizationFlow.canResumeExternalUserAgentFlow(with: url) {
            self.currentAuthService = nil
            return true
          }

        print("NOT HANDLED, failed, or smt else")
      // Handle other custom URL types.

      // If not handled by this app, return false.
      return false
    }
    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//
//        if let authService = self.currentAuthService, authService.canResumeExternalUserAgentFlow(with: url) {
//            return true
//        }
//
//        return false
//    }
}

