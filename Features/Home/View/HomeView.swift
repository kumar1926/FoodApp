//
//  HomeView.swift
//  FoodApp
//
//  Created by BizMagnets on 28/08/25.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var showLogoutAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.init(hex: "#1E1E2E")
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Welcome Section
                    VStack(spacing: 10) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.green)
                        
                        Text("Welcome!")
                            .font(.system(size: 32, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                        
                        if let email = authManager.currentUser?.email {
                            Text("Signed in as:")
                                .font(.system(size: 16, weight: .regular, design: .monospaced))
                                .foregroundColor(.gray)
                            
                            Text(email)
                                .font(.system(size: 18, weight: .semibold, design: .monospaced))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .multilineTextAlignment(.center)
                        }
                    }
                    
                    // User Info Card
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Account Information")
                            .font(.system(size: 20, weight: .bold, design: .monospaced))
                            .foregroundColor(.black)
                        
                        if let user = authManager.currentUser {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text("Email:")
                                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text(user.email ?? "N/A")
                                        .font(.system(size: 14, weight: .regular, design: .monospaced))
                                        .foregroundColor(.black)
                                }
                                
                                Divider()
                                
                                HStack {
                                    Text("User ID:")
                                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text(String(user.uid.prefix(8)) + "...")
                                        .font(.system(size: 14, weight: .regular, design: .monospaced))
                                        .foregroundColor(.black)
                                }
                                
                                Divider()
                                
                                HStack {
                                    Text("Verified:")
                                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text(user.isEmailVerified ? "Yes" : "No")
                                        .font(.system(size: 14, weight: .regular, design: .monospaced))
                                        .foregroundColor(user.isEmailVerified ? .green : .red)
                                }
                            }
                        }
                    }
                    .padding(25)
                    .background(Color.white)
                    .cornerRadius(15)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    // Sign Out Button
                    Button {
                        showLogoutAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("SIGN OUT")
                                .font(.system(size: 20, weight: .bold, design: .monospaced))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 50)
                }
                .padding(.top, 50)
            }
        }
        .navigationBarHidden(true)
        .alert("Sign Out", isPresented: $showLogoutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Sign Out", role: .destructive) {
                authManager.signOut()
            }
        } message: {
            Text("Are you sure you want to sign out?")
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthManager())
}

