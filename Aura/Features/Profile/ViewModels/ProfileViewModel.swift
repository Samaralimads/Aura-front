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
    private let baseURL: String
    
    var userName: String = ""
    var userEmail: String = ""
    var avatar: String = ""
    var lockedBadges: [UserProfileResponse.Badge] = []
    var unlockedBadges: [UserProfileResponse.Badge] = []
    var isLoading: Bool = false
    var error: Error?
    
    init(authService: AuthService = .shared, baseURL: String = "http://127.0.0.1:8080") {
        self.authService = authService
        self.baseURL = baseURL
        Task { await loadUserProfile() }
    }
    
    var avatarURL: String {
        let cleanedAvatar = avatar.replacingOccurrences(of: "avatars/", with: "")
        return "\(baseURL)/avatars/\(cleanedAvatar.isEmpty ? "default" : cleanedAvatar)"
    }
    
    func loadUserProfile() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let profile = try await authService.getUserProfile()
            await updateProfile(profile: profile)
        } catch {
            print("Erreur lors de la récupération du profil : \(error.localizedDescription)")
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
    
    private func updateProfile(profile: UserProfileResponse) async {
        await MainActor.run {
            self.userName = profile.firstName
            self.userEmail = profile.email
            self.avatar = profile.avatar
            self.lockedBadges = profile.lockedBadges
            self.unlockedBadges = profile.unlockedBadges
        }
    }
}
