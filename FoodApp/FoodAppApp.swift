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
    @StateObject private var authManager = AuthManager()
    @State private var showSplashView: Bool = true
    
    var body: some Scene {
        WindowGroup {
            Group {
                if showSplashView {
                    SplashView()
                        .onAppear {
                            // Show splash for 2.6 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    showSplashView = false
                                }
                            }
                        }
                } else {
                    // Main app content based on authentication state
                    if authManager.isLoading {
                        // Show loading while checking auth state
                       SplashView()
                    } else if authManager.isAuthenticated {
                        // User is signed in - show home
                        HomeView()
                            .environmentObject(authManager)
                    } else {
                        // User is not signed in - show login
                        LoginView()
                            .environmentObject(authManager)
                    }
                }
            }
        }
    }
}
