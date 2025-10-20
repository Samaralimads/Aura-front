//
//  Profile.swift
//  Aura
//
//  Created by Mehdi Legoullon on 17/10/2025.
//

import Foundation

struct UserProfileResponse: Codable {
    let id: String
    let email: String
    let firstName: String
    let avatar: String
    let lockedBadges: [Badge]
    let unlockedBadges: [Badge]
    
    struct Badge: Codable, Identifiable {
        let id: String
        let name: String
        let description: String
        let image: String
    }
}
