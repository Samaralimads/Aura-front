//
//  ProfileView.swift
//  Aura
//
//  Created by Samara Lima da Silva on 05/09/2025.
//

import SwiftUI


struct ProfileView: View {
    @Environment(AuthState.self) private var authState
    
    var body: some View {
        Button("Se déconnecter") {
            Task {
                do {
                    try await AuthService.shared.logout()
                    authState.logout()
                } catch {
                    authState.logout()
                }
            }
        }
    }
}


#Preview {
    ProfileView()
}
