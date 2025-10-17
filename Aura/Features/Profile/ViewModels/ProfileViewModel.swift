//
//  ProfileViewModel.swift
//  Aura
//
//  Created by Mehdi Legoullon on 17/10/2025.
//

import Foundation
import Observation

@Observable
final class ProfileViewModel {
    private let authService = AuthService.shared
    var userName: String = ""
    var userEmail: String = ""
    var userAvatar: String = ""
    var lockedBadges: [UserProfileResponse.Badge] = []
    var unlockedBadges: [UserProfileResponse.Badge] = []
    
    init() {
        Task { await loadUserProfile() }
    }
    
    private func loadUserProfile() async {
        do {
            let profile = try await authService.getUserProfile()
            DispatchQueue.main.async {
                self.userName = profile.firstName
                self.userEmail = profile.email
                self.userAvatar = profile.avatar
                self.lockedBadges = profile.lockedBadges
                self.unlockedBadges = profile.unlockedBadges
            }
        } catch {
            print("Erreur lors de la récupération du profil : \(error)")
        }
    }
}
