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
                        Text("EMAIL")
                            .font(.system(size: 14, weight: .regular, design: .monospaced))
                            .foregroundStyle(.gray)
                        TextField("Enter Email",text: $email)
                            .font(.system(size: 14, weight: .regular, design: .monospaced))
                            .foregroundStyle(.black)
                            .padding(15)
                            .background(Color.init(hex: "#F0F5FA"))
                            .cornerRadius(10)
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
                        }
                        .padding(15)
                        .background(Color.init(hex: "#F0F5FA"))
                        .cornerRadius(10)
                        
                        Button{
                            if password == confirmPassword && !password.isEmpty && !confirmPassword.isEmpty && !email.isEmpty && !name.isEmpty{
                                signUp()
                            }
                        }label: {
                            Text("SIGN UP")
                                .font(.system(size: 25, weight: .bold, design: .monospaced))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity,maxHeight: 25)
                                .padding()
                                .background(Color.init(hex: "#FF7622"))
                                .cornerRadius(10)
                            
                        }
                        
                        .padding(.top,20)
                        
                    }
                    .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .top)
                    .padding(.horizontal,20)
                    .padding(.top,40)
                    
                }
                .cornerRadius(25)
                
                
            }
            .padding(.top,50)
        }
    }
    func signUp(){
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error creating user: \(error)")
            } else {
                print("User created successfully")
            }
            
            guard let uid = authResult?.user.uid else { return }
            
            let db = Firestore.firestore()
            db.collection("users").document("user").setData([
                "uid": uid,
                "name": name,
                "email": email,
                "password": password,
                "createAt": FieldValue.serverTimestamp()
            ]){error in
                if let error = error {
                    print("Error writing document: \(error)")
                } else {
                    print("Document successfully written!")
                }
            }
        }
    }
}

#Preview {
    SignUpView()
}
