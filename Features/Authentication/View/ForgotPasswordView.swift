//
//  ForgotPasswordView.swift
//  FoodApp
//
//  Created by BizMagnets on 28/08/25.
//

import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) private var dismiss
    @State private var email: String = ""
    @State private var isLoading: Bool = false
    @State private var showAlert: Bool = false
    @State private var isSuccess: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.init(hex: "#1E1E2E")
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Reset Password")
                        .font(.system(size: 28, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                    
                    Text("Enter your email address and we'll send you a link to reset your password")
                        .font(.system(size: 14, weight: .regular, design: .monospaced))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("EMAIL")
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .foregroundStyle(.secondary)
                        
                        TextField("Enter your email", text: $email)
                            .font(.system(size: 14, weight: .regular, design: .monospaced))
                            .padding(15)
                            .background(Color.init(hex: "#F0F5FA"))
                            .cornerRadius(10)
                            .disabled(isLoading)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                        
                        Button {
                            resetPassword()
                        } label: {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                }
                                Text(isLoading ? "SENDING..." : "RESET PASSWORD")
                                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(!email.isEmpty && !isLoading ? Color.init(hex: "#FF7622") : Color.gray)
                            .cornerRadius(10)
                        }
                        .disabled(email.isEmpty || isLoading)
                        .padding(.top, 20)
                    }
                    .padding(30)
                    .background(Color.white)
                    .cornerRadius(25)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
                .padding(.top, 50)
                
                // Custom Alert Overlay
                if showAlert {
                    CustomAlertView(
                        isSuccess: isSuccess,
                        message: alertMessage,
                        onDismiss: {
                            showAlert = false
                            if isSuccess {
                                dismiss()
                            }
                        }
                    )
                    .zIndex(1)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Color.init(hex: "#FF7622"))
                }
            }
        }
    }
    
    private func resetPassword() {
        isLoading = true
        
        authManager.resetPassword(email: email) { [self] success, message in
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
    ForgotPasswordView()
        .environmentObject(AuthManager())
}
