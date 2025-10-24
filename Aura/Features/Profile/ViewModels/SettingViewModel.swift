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
    private let authService: AuthService
    
    var showAvatarSelection = false
    var avatars: [Avatar] = []
    var selectedAvatarURL: String?
    var isLoading = false
    var errorMessage: String?
    var successMessage: String?
    var avatar: String = ""
    
    init(profileViewModel: ProfileViewModel, authService: AuthService = .shared) {
        self.profileViewModel = profileViewModel
        self.authService = authService
        self.firstName = profileViewModel.userName
        self.email = profileViewModel.userEmail
        self.avatar = profileViewModel.avatar
    }
    
    func refreshProfile() async {
        isLoading = true
        errorMessage = nil
        
        await profileViewModel.loadUserProfile()
        firstName = profileViewModel.userName
        email = profileViewModel.userEmail
        avatar = profileViewModel.avatar
        
        isLoading = false
    }
    
    func updateUserProfile(firstName: String, email: String, password: String?, avatar: String? = nil) async {
        isLoading = true
        errorMessage = nil
        successMessage = nil
        
        do {
            _ = try await authService.update(
                avatar: avatar?.replacingOccurrences(of: "avatars/", with: ""),
                email: email,
                firstName: firstName,
                password: password?.isEmpty ?? true ? nil : password
            )
            
            if let avatar = avatar {
                self.avatar = avatar
                profileViewModel.avatar = avatar
            }
        } catch {
            errorMessage = "Erreur : \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    func loadAvatars() async {
        do {
            let avatars = try await authService.fetchAvatars()
            self.avatars = avatars
        } catch {
            errorMessage = "Erreur lors du chargement des avatars : \(error.localizedDescription)"
        }
    }
    
    // MARK: - Properties liées à ProfileViewModel
    var firstName: String {
        get { profileViewModel.userName }
        set { profileViewModel.userName = newValue }
    }
    
    var email: String {
        get { profileViewModel.userEmail }
        set { profileViewModel.userEmail = newValue }
    }
    
    var avatarURL: String {
        profileViewModel.avatarURL
    }
    
    // MARK: - URL Helpers
    func getAvatarImageURL(_ imagePath: String) -> URL? {
        let cleanedPath = imagePath
            .replacingOccurrences(of: "avatars/", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        let urlString = "\(AuthService.baseURL)/avatars/\(cleanedPath)"
        return URL(string: urlString)
    }
}
