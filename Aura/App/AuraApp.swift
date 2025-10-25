//
//  AuraApp.swift
//  Aura
//
//  Created by Samara Lima da Silva on 04/09/2025.
//

import SwiftUI
import Observation

@main
struct AuraApp: App {
    @State private var authState = AppState()
    
    var body: some Scene {
        WindowGroup {
            if authState.isOnboardingNeeded {
                OnBoardingView()
                    .environment(authState)
            } else if authState.isLoggedIn {
                TabBar()
                    .environment(authState)
            } else {
                LoginView()
                    .environment(authState)
            }
        }
    }
}
