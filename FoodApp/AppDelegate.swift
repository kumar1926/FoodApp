//
//  AppDelegate.swift
//  FoodApp
//
//  Created by BizMagnets on 19/08/25.
//

import UIKit
import FirebaseCore
import FirebaseAppCheck
class AppDelegate: NSObject,UIApplicationDelegate{
    func application(_ application: UIApplication,
                       didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        AppCheck.setAppCheckProviderFactory(AppCheckDebugProviderFactory())

        return true
      }
}
