//
//  BadgeViewModel.swift
//  Aura
//
//  Created by Mehdi Legoullon on 19/10/2025.
//

import Foundation
import Observation

@Observable
class BadgeViewModel {
    var unlockedBadges: [UserProfileResponse.Badge] = []
    var lockedBadges: [UserProfileResponse.Badge] = []
    var isLoading = false
    var error: Error?
    
    private let baseURL = "http://127.0.0.1:8080"
    private let authService = AuthService()
    
    func fetchUserBadges() async {
        isLoading = true
        error = nil
        
        do {
            let profile = try await authService.getUserProfile()
            unlockedBadges = profile.unlockedBadges
            lockedBadges = profile.lockedBadges
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    func getBadgeImageURL(_ imageName: String) -> URL? {
        let cleanedImageName = imageName.replacingOccurrences(
            of: "/Badges/",
            with: ""
        )
        return URL(string: "\(baseURL)/Badges/\(cleanedImageName)")
    }
}
