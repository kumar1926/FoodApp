//
//  SplashView.swift
//  FoodApp
//
//  Created by BizMagnets on 19/08/25.
//

import SwiftUI

struct SplashView: View {
    @State private var fadeInOut = false
    var body: some View {
        ZStack(alignment:.center){
            Image("Logo")
                .resizable()
                .frame(width: 200, height: 150)
                .opacity(fadeInOut ? 1.0 : 0.2)
                .animation(.easeInOut(duration: 1.3).repeatForever(autoreverses: true),value: fadeInOut)
        }
        .onAppear{
            fadeInOut = true
        }
            
    }
}

#Preview {
    SplashView()
}
