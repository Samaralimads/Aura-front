//
//  LoginViewModel.swift
//  Aura
//
//  Created by Mehdi Legoullon on 10/10/2025.
//


import Foundation
import Observation

@Observable
final class LoginViewModel {
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
    
    func login() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await authService.login(
                email: email,
                password: password
            )
            UserDefaults.standard.set(response.token, forKey: "userToken")
            authState.setLoggedIn(true)
        } catch {
            errorMessage = "Erreur de connexion : \(error.localizedDescription)"
            
            if let urlError = error as? URLError {
                print("Code d'erreur : \(urlError.errorCode)")
                print("Description : \(urlError.localizedDescription)")
            }
        }
        
        isLoading = false
    }
}

