//
//  SettingViewModel.swift
//  Aura
//
//  Created by Mehdi Legoullon on 23/10/2025.
//

import Foundation
import Observation

@Observable
@MainActor
final class SettingViewModel {
    private let profileViewModel: ProfileViewModel
    private let authService = AuthService.shared
    
    var firstName: String {
        profileViewModel.userName
    }
    
    var email: String {
        profileViewModel.userEmail
    }
    
    var avatarURL: String {
        profileViewModel.avatarURL
    }
    
    var isLoading: Bool = false
    var errorMessage: String?
    var successMessage: String?
    
    init(profileViewModel: ProfileViewModel) {
        self.profileViewModel = profileViewModel
    }
    
    func refreshProfile() async {
        errorMessage = nil
        await profileViewModel.loadUserProfile()
    }
    
    func updateUserProfile(firstName: String, email: String, password: String?) async {
        isLoading = true
        errorMessage = nil
        successMessage = nil
        
        do {
            let response = try await authService.update(
                avatar: nil,
                email: email,
                firstName: firstName,
                password: password?.isEmpty ?? true ? nil : password
            )
            successMessage = "Profil mis à jour avec succès !"
            
            await refreshProfile()
        } catch {
            print("Erreur complète : \(error)")
            errorMessage = "Erreur : \(error.localizedDescription)"
        }
        isLoading = false
    }
}
