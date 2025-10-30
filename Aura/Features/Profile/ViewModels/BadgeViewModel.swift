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
    let lockURL = "http://127.0.0.1:8080/Badges/lock.png"
    
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
    
    func getUnlockBadgeIconName(_ badge: UserProfileResponse.Badge) -> String {
        let mapper = BadgeStyleMapper()
        let style = mapper.style(for: badge.name)
        return style.iconName
    }

    
    func getLockBadgeImageURL(_ imageName: String) -> URL? {
        return URL(string: lockURL)
    }
    
    // MARK: - Preview Data
    static func preview() -> BadgeViewModel {
        let viewModel = BadgeViewModel()
        viewModel.unlockedBadges = [
            UserProfileResponse.Badge(
                id: "1",
                name: "First Meditation",
                description: "Completed your first meditation session.",
                image: "/Badges/leaf.png"
            ),
            UserProfileResponse.Badge(
                id: "2",
                name: "First Challenge",
                description: "Completed your first challenge.",
                image: "/Badges/wind.png"
            )
        ]
        viewModel.lockedBadges = [
            UserProfileResponse.Badge(
                id: "3",
                name: "Advanced Meditation",
                description: "Completed an advanced meditation session.",
                image: "/Badges/lock.png"
            ),
            UserProfileResponse.Badge(
                id: "4",
                name: "Advanced Challenge",
                description: "Completed an advanced challenge.",
                image: "/Badges/lock.png"
            )
        ]
        return viewModel
    }
}
