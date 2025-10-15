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
    
    private let loginService = AuthService.shared
    
    func login() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await loginService.login(email: email, password: password)
            UserDefaults.standard.set(response.token, forKey: "userToken")
            isLoggedIn = true
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
