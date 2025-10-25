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
    
    func login() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await authService.login(email: email, password: password)
            UserDefaults.standard.set(response.token, forKey: "userToken")
            
            if let token = UserDefaults.standard.string(forKey: "userToken"), !token.isEmpty {
                isLoggedIn = true
            } else {
                errorMessage = "Erreur lors de la sauvegarde du token"
            }
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
