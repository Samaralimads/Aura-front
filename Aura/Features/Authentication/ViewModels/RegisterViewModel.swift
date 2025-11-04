//
//  RegisterViewModel.swift
//  Aura
//
//  Created by Mehdi Legoullon on 16/10/2025.
//

import Foundation
import Observation

@Observable
final class RegisterViewModel {
    var firstName: String = ""
    var email: String = ""
    var password: String = ""
    var errorMessage: String?
    var isLoading = false
    var isLoggedIn = false
    
    private let authService = AuthService.shared
    private let authState: AppState
    
    init(authState: AppState) {
        self.authState = authState
    }
    
    func register() async {
        isLoading = true
        errorMessage = nil
        
        guard !email.isEmpty, !password.isEmpty, !firstName.isEmpty else {
            errorMessage = "Veuillez remplir tous les champs."
            isLoading = false
            return
        }
        
        do {
            let response = try await authService.register(
                firstName: firstName,
                email: email,
                password: password
            )
            UserDefaults.standard.set(response.token, forKey: "userToken")
            authState.setLoggedIn(true)
            authState.isOnboardingNeeded = true
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
