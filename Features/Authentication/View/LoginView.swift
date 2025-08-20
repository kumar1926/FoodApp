//
//  LoginView.swift
//  FoodApp
//
//  Created by BizMagnets on 19/08/25.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        ZStack{
            Color.init(hex: "#1E1E2E")
                .ignoresSafeArea()
            
            VStack(spacing:10){
                Text("Log In")
                    .font(.system(size: 30, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                Text("Please sign in to your existing account")
                    .font(.system(size: 14, weight: .regular, design: .monospaced))
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 10){
                    
                    Text( "Email" )
                        .font(.system(size: 14,weight: .bold,design: .monospaced))
                        .foregroundStyle(Color.white)
                }
            }
            
        }
    }
}

#Preview {
    LoginView()
}
