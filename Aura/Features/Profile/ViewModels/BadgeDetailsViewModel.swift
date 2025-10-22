//
//  BadgeDetailsViewModel.swift
//  Aura
//
//  Created by Mehdi Legoullon on 20/10/2025.
//

import SwiftUI
import Observation


@Observable
class BadgeDetailsViewModel {
    let badge: UserProfileResponse.Badge
    let isLocked: Bool
    var isLoading = false
    
    private let baseURL = "http://127.0.0.1:8080"
    private let lockURL = "http://127.0.0.1:8080/Badges/lock.png"
    
    init(badge: UserProfileResponse.Badge, isLocked: Bool) {
        self.badge = badge
        self.isLocked = isLocked
    }
    
    func getBadgeFullPage(_ imageName: String) -> URL? {
        if isLocked {
            return URL(string: lockURL)
        } else {
            let cleanedImageName = imageName.replacingOccurrences(of: "/Badges/", with: "")
            return URL(string: "\(baseURL)/Badges/\(cleanedImageName)")
        }
    }
}
