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
    var userName: String = ""
    var userEmail: String = ""
    var userAvatar: String = ""
    var lockedBadges: [UserProfileResponse.Badge] = []
    var unlockedBadges: [UserProfileResponse.Badge] = []
    var isLoading: Bool = false
    
    private let authService = AuthService.shared
    private let authState: AppState
    
    init(authState: AppState) {
        self.authState = authState
        Task { await loadUserProfile() }
    }
    
    private func loadUserProfile() async {
        do {
            let profile = try await authService.getUserProfile()
            await MainActor.run {
                userName = profile.firstName
                userEmail = profile.email
                userAvatar = profile.avatar
                lockedBadges = profile.lockedBadges
                unlockedBadges = profile.unlockedBadges
            }
        } catch {
            print("Erreur lors de la récupération du profil : \(error)")
        }
    }
    
    func logout() async {
        isLoading = true
        do {
            try await authService.logout()
            UserDefaults.standard.removeObject(forKey: "userToken")            
            authState.setLoggedIn(false)
            authState.isOnboardingNeeded = false
            authState.selectedTab = 0
        } catch {
            print("Erreur lors de la déconnexion : \(error)")
        }
        isLoading = false
    }
}
