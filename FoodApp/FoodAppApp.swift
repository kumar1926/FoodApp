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
    @State private var showSplashView: Bool = true
    var body: some Scene {
        WindowGroup {
            if showSplashView{
                SplashView()
                    .onAppear(){
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) {
                            withAnimation{
                                showSplashView = false
                            }
                        }
                    }
            }else{
                LoginView()
            }
            
        }
    }
}
