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
    private let baseURL = "http://127.0.0.1:8080"
    private var isFetching = false
    
    func fetchUserBadges() async {
        guard !isFetching else { return }
        isFetching = true
        defer { isFetching = false }
        
        do {
            let profile = try await AuthService.shared.getUserProfile()
            unlockedBadges = profile.unlockedBadges
            lockedBadges = profile.lockedBadges
        } catch {
            print("Erreur : \(error)")
        }
    }
    
    func isBadgeUnlocked(_ badgeId: String) -> Bool {
        return unlockedBadges.contains { $0.id == badgeId }
    }
    
    func unlockBadge(badgeId: String) async {
        await fetchUserBadges()
        
        if unlockedBadges.contains(where: { $0.id == badgeId }) {
            return
        }
        
        guard let url = URL(string: "\(baseURL)/badges/unlock") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = AuthService.shared.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let body: [String: Any] = ["badgeID": badgeId]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        do {
            let (_, _) = try await URLSession.shared.data(for: request)
            await fetchUserBadges()
        } catch {
            print("⚠️ Erreur réseau : \(error.localizedDescription)")
        }
    }

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
    
    func getBadgeName(by id: String) -> String? {
        unlockedBadges.first { $0.id == id }?.name
    }
}
