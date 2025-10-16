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
