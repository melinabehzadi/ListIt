//
//  SplashView.swift
//  ListIt
//
//  Created by melina behzadi on 2025-02-25.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @StateObject private var dataManager = DataManager() // Initialize DataManager

    var body: some View {
        ZStack {
            // Background Color
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            // App Logo & Title
            VStack {
                Image(systemName: "cart.fill") // Replace with your actual app logo
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(Color("AccentColor"))
                
                Text("ListIt")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("TextColor"))
                
                Text("Your smart shopping list")
                    .font(.title3)
                    .foregroundColor(Color("TextColor").opacity(0.8))
                    .padding(.top, 5)
            }
            .opacity(isActive ? 1 : 0) // Fade in effect
            .animation(.easeIn(duration: 1.2), value: isActive)
        }
        .onAppear {
            isActive = true
            // Load stored data before transitioning
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    isActive = false
                    switchToHome()
                }
            }
        }
    }
    
    private func switchToHome() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first else {
            return
        }
        
        window.rootViewController = UIHostingController(rootView: HomeView(dataManager: dataManager)) // Pass dataManager
        window.makeKeyAndVisible()
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
