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
    private let authService: AuthService
    
    var userName: String = ""
    var userEmail: String = ""
    var avatar: String = ""
    var lockedBadges: [UserProfileResponse.Badge] = []
    var unlockedBadges: [UserProfileResponse.Badge] = []
    var isLoading: Bool = false
    var error: Error?
    
    init(authService: AuthService = .shared) {
        self.authService = authService
        Task { await loadUserProfile() }
    }
    
    var avatarURL: String {
        let cleanedAvatar = avatar.replacingOccurrences(of: "avatars/", with: "")
        let avatarName = cleanedAvatar.isEmpty ? "default" : cleanedAvatar
        return "\(AuthService.baseURL)/avatars/\(avatarName)"
    }
    
    func loadUserProfile() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let profile = try await authService.getUserProfile()
            updateProfile(profile: profile)
        } catch {
            await MainActor.run {
                self.error = error
                self.avatar = "avatars/default.png"
            }
        }
    }
    
    func logout() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await authService.logout()
            UserDefaults.standard.removeObject(forKey: "userToken")
        } catch {
            print("Erreur lors de la déconnexion : \(error.localizedDescription)")
        }
    }
    
    private func updateProfile(profile: UserProfileResponse) {
        userName = profile.firstName
        userEmail = profile.email
        avatar = profile.avatar
        lockedBadges = profile.lockedBadges
        unlockedBadges = profile.unlockedBadges
    }
}
