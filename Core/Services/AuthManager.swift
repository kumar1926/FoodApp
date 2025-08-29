//
//  AuthManager.swift
//  FoodApp
//
//  Created by BizMagnets on 28/08/25.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import Combine

class AuthManager: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var isLoading = true
    
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    private let db = Firestore.firestore()
    
    init() {
        setupAuthStateListener()
    }
    
    deinit {
        if let handle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    // MARK: - Auth State Management
    
    private func setupAuthStateListener() {
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            DispatchQueue.main.async {
                self?.currentUser = user
                self?.isAuthenticated = user != nil
                self?.isLoading = false
                print("Auth state changed - User: \(user?.email ?? "nil")")
            }
        }
    }
    
    // MARK: - Sign In
    
    func signIn(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard isValidEmail(trimmedEmail) else {
            completion(false, "Please enter a valid email address.")
            return
        }
        
        guard !password.isEmpty else {
            completion(false, "Please enter your password.")
            return
        }
        
        Auth.auth().signIn(withEmail: trimmedEmail, password: password) { [weak self] authResult, error in
            DispatchQueue.main.async {
                if let error = error {
                    let errorMessage = self?.getFirebaseErrorMessage(error) ?? "An unknown error occurred."
                    completion(false, errorMessage)
                } else {
                    completion(true, "Successfully signed in!")
                }
            }
        }
    }
    
    // MARK: - Sign Out
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            print("User signed out successfully")
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Password Reset
    
    func resetPassword(email: String, completion: @escaping (Bool, String) -> Void) {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard isValidEmail(trimmedEmail) else {
            completion(false, "Please enter a valid email address.")
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: trimmedEmail) { error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(false, self.getFirebaseErrorMessage(error))
                } else {
                    completion(true, "Password reset email sent successfully. Check your inbox.")
                }
            }
        }
    }
    
    // MARK: - Helper Functions
    
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
        case .invalidEmail:
            return "Please enter a valid email address."
        case .userNotFound:
            return "No account found with this email address."
        case .wrongPassword:
            return "Incorrect password. Please try again."
        case .userDisabled:
            return "This account has been disabled. Please contact support."
        case .tooManyRequests:
            return "Too many failed attempts. Please try again later."
        case .networkError:
            return "Network error. Please check your connection."
        case .invalidCredential:
            return "Invalid email or password. Please check your credentials."
        default:
            return authError.localizedDescription
        }
    }
}
