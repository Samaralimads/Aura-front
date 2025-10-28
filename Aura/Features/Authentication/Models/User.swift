//
//  User.swift
//  Aura
//
//  Created by Mehdi Legoullon on 10/10/2025.
//

import Foundation

// MARK: - Login DTOs
struct UserLoginRequest: Codable {
    let email: String
    let password: String
}

struct UserLoginResponse: Codable {
    let token: String
    let firstName: String
}

// MARK: - Logout DTO
struct LogoutResponseDTO: Codable {
    let success: Bool
    let message: String
}

// MARK: - Register User DTOs
struct UserRegisterRequest: Codable {
    let firstName: String
    let email: String
    let password: String
}

struct UserRegisterResponse: Codable {
    let firstName: String
    let token: String
}

// MARK: - Update User DTOs
struct UserUpdateRequest: Codable {
    let avatar: String?
    let email: String?
    let firstName: String?
    let password: String?
}

struct UserUpdateResponse: Codable {
    let id: String
    let firstName: String
    let email: String
    let avatar: String
}
