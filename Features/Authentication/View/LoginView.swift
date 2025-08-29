//
//  LoginView.swift
//  FoodApp
//
//  Created by BizMagnets on 19/08/25.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @StateObject private var authManager = AuthManager()
    @State private var isPasswordVisible: Bool = false
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoading: Bool = false
    @State private var showAlert: Bool = false
    @State private var isSuccess: Bool = false
    @State private var alertMessage: String = ""
    @State private var showForgotPassword: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.init(hex: "#1E1E2E")
                    .ignoresSafeArea()
                
                VStack(spacing: 10) {
                    Text("Log In")
                        .font(.system(size: 30, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                    Text("Please sign in to your existing account")
                        .font(.system(size: 14, weight: .regular, design: .monospaced))
                        .foregroundColor(.white)
                    
                    Spacer(minLength: 40)
                    ZStack(alignment: .leading) {
                        Color.white
                        
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Email")
                                .font(.system(size: 14, weight: .bold, design: .monospaced))
                                .foregroundStyle(.secondary)
                            TextField("example123@gmail.com", text: $email)
                                .font(.system(size: 14, weight: .regular, design: .monospaced))
                                .padding(15)
                                .background(Color.init(hex: "#F0F5FA"))
                                .cornerRadius(10)
                                .disabled(isLoading)
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                            
                            Text("Password")
                                .font(.system(size: 14, weight: .bold, design: .monospaced))
                                .foregroundStyle(.secondary)
                            HStack {
                                if isPasswordVisible {
                                    TextField("Enter Password", text: $password)
                                        .font(.system(size: 14, weight: .regular, design: .monospaced))
                                        .foregroundStyle(.black)
                                } else {
                                    SecureField("**********", text: $password)
                                        .font(.system(size: 14, weight: .regular, design: .monospaced))
                                        .foregroundStyle(.black)
                                }
                                Button(action: {
                                    isPasswordVisible.toggle()
                                }) {
                                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                        .foregroundStyle(.secondary)
                                }
                                .disabled(isLoading)
                            }
                            .padding(15)
                            .background(Color.init(hex: "#F0F5FA"))
                            .cornerRadius(10)
                            
                            Button {
                                showForgotPassword = true
                            } label: {
                                Text("Forgot Password")
                                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                                    .foregroundStyle(Color.init(hex: "#FF7622"))
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.top)
                            .disabled(isLoading)
                            
                            Button {
                                signIn()
                            } label: {
                                HStack {
                                    if isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                            .scaleEffect(0.8)
                                    }
                                    Text(isLoading ? "SIGNING IN..." : "SIGN IN")
                                        .font(.system(size: isLoading ? 20 : 25, weight: .bold, design: .monospaced))
                                        .foregroundStyle(.white)
                                }
                                .frame(maxWidth: .infinity, maxHeight: 25)
                                .padding()
                                .background(isFormValid() && !isLoading ? Color.init(hex: "#FF7622") : Color.gray)
                                .cornerRadius(10)
                            }
                            .disabled(!isFormValid() || isLoading)
                            .padding(.top, 20)
                            
                            HStack {
                                Text("Don't have an account?")
                                    .font(.system(size: 14, weight: .regular, design: .monospaced))
                                    .foregroundStyle(Color.gray)
                                
                                NavigationLink(destination: SignUpView()) {
                                    Text("Sign Up")
                                        .font(.system(size: 14, weight: .regular, design: .monospaced))
                                        .foregroundStyle(Color.init(hex: "#FF7622"))
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 10)
                            .padding(.top, 20)
                        }
                        .padding(.top, 50)
                        .frame(maxHeight: .infinity, alignment: .init(horizontal: .center, vertical: .top))
                        .padding([.leading, .trailing], 20)
                    }
                    .cornerRadius(25)
                }.padding(.top, 50)
                
                // Custom Alert Overlay
                if showAlert {
                    CustomAlertView(
                        isSuccess: isSuccess,
                        message: alertMessage,
                        onDismiss: {
                            showAlert = false
                        }
                    )
                    .zIndex(1)
                }
            }
        }
        .sheet(isPresented: $showForgotPassword) {
            ForgotPasswordView()
                .environmentObject(authManager)
        }
    }
    
    // MARK: - Helper Functions
    
    private func isFormValid() -> Bool {
        return !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               !password.isEmpty
    }
    
    private func signIn() {
        isLoading = true
        
        authManager.signIn(email: email, password: password) { [self] success, message in
            DispatchQueue.main.async {
                isLoading = false
                isSuccess = success
                alertMessage = message
                showAlert = true
            }
        }
    }
}

#Preview {
    LoginView()
}
