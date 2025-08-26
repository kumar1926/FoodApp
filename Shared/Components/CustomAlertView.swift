//
//  CustomAlertView.swift
//  FoodApp
//
//  Created by Kumar AK on 24/08/25.
//

import SwiftUI

struct CustomAlertView: View {
    let isSuccess: Bool
    let message: String
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }
            
            VStack(spacing: 20) {
                Image(systemName: isSuccess ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(isSuccess ? .green : .red)
                
                Text(message)
                    .font(.system(size: 16, weight: .medium, design: .monospaced))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Button{
                    onDismiss()
                }label: {
                    Text(isSuccess ? "Done" : "Cancel")
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(isSuccess ? Color.green : Color.red)
                }
                .cornerRadius(10)
                .padding(.horizontal)
            }
            .frame(maxWidth: 300)
            .padding(30)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
        }
    }
}


#Preview {
    CustomAlertView(isSuccess: true, message: "success", onDismiss: {})
}
