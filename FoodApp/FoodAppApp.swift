//
//  FoodAppApp.swift
//  FoodApp
//
//  Created by BizMagnets on 19/08/25.
//

import SwiftUI

@main
struct FoodAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            SplashView()
        }
    }
}
