//
//  SignUpView.swift
//  FoodApp
//
//  Created by BizMagnets on 21/08/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignUpView: View {
    @State var name:String = ""
    @State var email:String = ""
    @State var password:String = ""
    @State var confirmPassword:String = ""
    @State var isPasswordVisible:Bool = false
    @State var isConfirmPasswordVisible:Bool = false
    @State var showAlert: Bool = false
    @State var isSuccess: Bool = false
    @State var alertMessage: String = ""
    @State var isLoading: Bool = false
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack(alignment: .topLeading){
            Color.init(hex: "#1E1E2E")
                .ignoresSafeArea()
            
            VStack(spacing:10){
                Text("Sign Up")
                    .font(.system(size: 24, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                Text("Please sign up to get started")
                    .font(.system(size: 14, weight: .regular, design: .monospaced))
                    .foregroundStyle(Color.white)
                Spacer(minLength: 40)
                ZStack(alignment:.leading){
                    Color.white
                    VStack(alignment:.leading,spacing:10){
                        Text("NAME")
                            .font(.system(size: 14, weight: .regular, design: .monospaced))
                            .foregroundStyle(.gray)
                        TextField("Enter Name",text: $name)
                            .font(.system(size: 14, weight: .regular, design: .monospaced))
                            .foregroundStyle(.black)
                            .padding(15)
                            .background(Color.init(hex: "#F0F5FA"))
                            .cornerRadius(10)
                            .disabled(isLoading)
                        
                        Text("EMAIL")
                            .font(.system(size: 14, weight: .regular, design: .monospaced))
                            .foregroundStyle(.gray)
                        TextField("Enter Email",text: $email)
                            .font(.system(size: 14, weight: .regular, design: .monospaced))
                            .foregroundStyle(.black)
                            .padding(15)
                            .background(Color.init(hex: "#F0F5FA"))
                            .cornerRadius(10)
                            .disabled(isLoading)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                        
                        Text("PASSWORD")
                            .font(.system(size: 14, weight: .regular, design: .monospaced))
                            .foregroundStyle(.gray)
                        HStack {
                            if isPasswordVisible {
                                TextField("Enter Password", text: $password)
                                    .font(.system(size: 14, weight: .regular, design: .monospaced))
                                    .foregroundStyle(.black)
                            } else {
                                SecureField("***********", text: $password)
                                    .font(.system(size: 14, weight: .regular, design: .monospaced))
                                    .foregroundStyle(.black)
                            }
                            Button {
                                isPasswordVisible.toggle()
                            } label: {
                                Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundStyle(.secondary)
                            }
                            .disabled(isLoading)
                        }
                        .padding(15)
                        .background(Color.init(hex: "#F0F5FA"))
                        .cornerRadius(10)
                        
                        Text("RE-TYPE PASSWORD")
                            .font(.system(size: 14, weight: .regular, design: .monospaced))
                            .foregroundStyle(.gray)
                        HStack{
                            if isConfirmPasswordVisible{
                                TextField("Enter Password",text: $confirmPassword)
                                    .font(.system(size: 14, weight: .regular, design: .monospaced))
                                    .foregroundStyle(.black)
                                
                            }else{
                                SecureField("***********",text: $confirmPassword)
                                    .font(.system(size: 14, weight: .regular, design: .monospaced))
                                    .foregroundStyle(.black)
                                
                            }
                            Button(action:{
                                isConfirmPasswordVisible.toggle()
                            }){
                                Image(systemName: isConfirmPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundStyle(.secondary)
                            }
                            .disabled(isLoading)
                        }
                        .padding(15)
                        .background(Color.init(hex: "#F0F5FA"))
                        .cornerRadius(10)
                        
                        Button{
                            signUp()
                        } label: {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                }
                                Text(isLoading ? "SIGNING UP..." : "SIGN UP")
                                    .font(.system(size: isLoading ? 20 : 25, weight: .bold, design: .monospaced))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity, maxHeight: 25)
                            .padding()
                            .background(isFormValid() && !isLoading ? Color.init(hex: "#FF7622") : Color.gray)
                            .cornerRadius(10)
                        }
                        .disabled(!isFormValid() || isLoading)
                        .padding(.top, 20)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .padding(.horizontal, 20)
                    .padding(.top, 40)
                }
                .cornerRadius(25)
            }
            .padding(.top, 50)
            if showAlert{
                CustomAlertView(isSuccess: isSuccess, message: alertMessage, onDismiss:{
                    showAlert = false
                    if isSuccess{
                        dismiss()
                    }
                })
                .zIndex(1)
            }
        }
    }
    func signUp() {
        // Validate form before proceeding
        guard isFormValid() else {
            showAlert(success: false, message: "Please fill in all fields correctly and ensure passwords match.")
            return
        }
        
        isLoading = true
        
        Auth.auth().createUser(withEmail: email.trimmingCharacters(in: .whitespacesAndNewlines),
                               password: password) { [self] authResult, error in
            DispatchQueue.main.async {
                isLoading = false
                
                if let error = error {
                    let errorMessage = getFirebaseErrorMessage(error)
                    showAlert(success: false, message: errorMessage)
                    return
                }
                
                guard let uid = authResult?.user.uid else {
                    showAlert(success: false, message: "Failed to get user information. Please try again.")
                    return
                }
                
                // Save user data to Firestore
                saveUserToFirestore(uid: uid)
            }
        }
    }
    
    private func saveUserToFirestore(uid: String) {
        let db = Firestore.firestore()
        let userData: [String: Any] = [
            "uid": uid,
            "name": name.trimmingCharacters(in: .whitespacesAndNewlines),
            "email": email.trimmingCharacters(in: .whitespacesAndNewlines),
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        db.collection("users").document(uid).setData(userData) { [self] error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Firestore error: \(error.localizedDescription)")
                    showAlert(success: true, message: "Account created successfully! Welcome to the app.")
                } else {
                    showAlert(success: true, message: "Account created successfully! You can now log in with your credentials.")
                }
            }
        }
    }
    private func isFormValid() -> Bool {
        return !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !password.isEmpty &&
        !confirmPassword.isEmpty &&
        password == confirmPassword &&
        password.count >= 6 &&
        isValidEmail(email)
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func getFirebaseErrorMessage(_ error: Error) -> String {
        guard let authError = error as NSError? else {
            return "An unknown error occurred. Please try again."
        }
        
        switch AuthErrorCode(rawValue: authError.code) {
        case .emailAlreadyInUse:
            return "This email address is already registered. Please use a different email or try logging in."
        case .invalidEmail:
            return "Please enter a valid email address."
        case .operationNotAllowed:
            return "Email/password accounts are not enabled. Please contact support."
        case .weakPassword:
            return "Password is too weak. Please choose a stronger password with at least 6 characters."
        case .networkError:
            return "Network error. Please check your internet connection and try again."
        case .tooManyRequests:
            return "Too many attempts. Please wait a moment before trying again."
        default:
            return authError.localizedDescription
        }
    }
    private func showAlert(success: Bool, message: String) {
        isSuccess = success
        alertMessage = message
        showAlert = true
    }
}

#Preview {
    SignUpView()
}
