//
//  User.swift
//  Aura
//
//  Created by Mehdi Legoullon on 10/10/2025.
//

import Foundation

// UserLoginRequest.swift
struct UserLoginRequest: Codable {
    let email: String
    let password: String
}

// UserLoginResponse.swift
struct UserLoginResponse: Codable {
    let token: String
    let firstName: String
}

struct LogoutResponseDTO: Codable {
    let success: Bool
    let message: String
}
