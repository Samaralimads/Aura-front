//
//  SettingViewModel.swift
//  Aura
//
//  Created by Mehdi Legoullon on 23/10/2025.
//

import Foundation
import Observation

@Observable
final class SettingViewModel {
    private let profileViewModel: ProfileViewModel
    
    var firstName: String {
        profileViewModel.userName
    }
    
    var email: String {
        profileViewModel.userEmail
    }
    
    var avatarURL: String {
        profileViewModel.avatarURL
    }
    
    var isLoading: Bool {
        profileViewModel.isLoading
    }
    
    var errorMessage: String?
    
    init(profileViewModel: ProfileViewModel) {
        self.profileViewModel = profileViewModel
    }
    
    @MainActor
    func refreshProfile() async {
        errorMessage = nil
        do {
            try await profileViewModel.loadUserProfile()
        } catch {
            errorMessage = "Impossible de charger le profil : \(error.localizedDescription)"
            print(error.localizedDescription)
        }
    }
}
