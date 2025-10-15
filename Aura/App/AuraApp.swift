//
//  AuraApp.swift
//  Aura
//
//  Created by Samara Lima da Silva on 04/09/2025.
//

import SwiftUI
import Observation

@Observable
final class AuthState {
    var isLoggedIn: Bool
    
    init() {
        self.isLoggedIn = UserDefaults.standard.string(forKey: "userToken") != nil
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "userToken")
        isLoggedIn = false
    }
}

@main
struct AuraApp: App {
    @State private var authState = AuthState()
    
    var body: some Scene {
        WindowGroup {
            if authState.isLoggedIn {
                TabBar()
                    .environment(authState)
            } else {
                LoginView()
                    .environment(authState)
            }
        }
    }
}
