//
//  User.swift
//  Aura
//
//  Created by Mehdi Legoullon on 10/10/2025.
//

import Foundation


struct UserLoginRequest: Codable {
    let email: String
    let password: String
}


struct UserLoginResponse: Codable {
    let token: String
    let firstName: String
}


struct LogoutResponseDTO: Codable {
    let success: Bool
    let message: String
}


struct UserRegisterRequest: Codable {
    let firstName: String
    let email: String
    let password: String
}


struct UserRegisterResponse: Codable {
    let firstName: String
    let token: String
}


struct UserProfileResponse: Codable {
    let id: String
    let email: String
    let firstName: String
    let avatar: String
    let lockedBadges: [Badge]
    let unlockedBadges: [Badge]
    
    struct Badge: Codable {
        let id: String
        let name: String
        let description: String
        let image: String
    }
}
