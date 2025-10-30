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
    var successMessage: String? = nil
    var avatar: String = ""
    var shouldNavigateToLogin = false
    
    init(profileViewModel: ProfileViewModel, authService: AuthService = .shared) {
        self.profileViewModel = profileViewModel
        self.authService = authService
        self.firstName = profileViewModel.userName
        self.email = profileViewModel.userEmail
        self.avatar = profileViewModel.avatar
    }
    
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
        
        let oldFirstName = self.firstName
        let oldEmail = self.email
        let oldAvatar = self.avatar
        
        let hasChanges = (oldFirstName != firstName) ||
        (oldEmail != email) ||
        (oldAvatar != avatar) ||
        !(password?.isEmpty ?? true)
        
        guard hasChanges else {
            isLoading = false
            return
        }
        
        do {
            _ = try await authService.update(
                avatar: avatar?.replacingOccurrences(of: "avatars/", with: ""),
                email: email,
                firstName: firstName,
                password: password?.isEmpty ?? true ? nil : password
            )
            
            self.firstName = firstName
            self.email = email
            profileViewModel.userName = firstName
            profileViewModel.userEmail = email
            
            if let avatar = avatar {
                self.avatar = avatar
                profileViewModel.avatar = avatar
            }
            
            var modifiedFields: [String] = []
            if oldFirstName != firstName { modifiedFields.append("prénom") }
            if oldEmail != email { modifiedFields.append("email") }
            if oldAvatar != avatar { modifiedFields.append("avatar") }
            if !(password?.isEmpty ?? true) { modifiedFields.append("mot de passe") }
            
            if !modifiedFields.isEmpty {
                successMessage = modifiedFields.count == 1 ?
                "\(modifiedFields[0].capitalized) modifié" :
                "\(modifiedFields.joined(separator: ", ")) modifiés"
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
    
    func getAvatarImageURL(_ imagePath: String) -> URL? {
        let cleanedPath = imagePath
            .replacingOccurrences(of: "avatars/", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        let urlString = "\(AuthService.baseURL)/avatars/\(cleanedPath)"
        return URL(string: urlString)
    }
    
    func deleteAccount() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let userID = try await authService.getUserID()
            try await authService.deleteAccount(userID: userID)
            UserDefaults.standard.removeObject(forKey: "userToken")
            shouldNavigateToLogin = true
        } catch {
            errorMessage = "Erreur lors de la suppression du compte : \(error.localizedDescription)"
        }
    }
}
