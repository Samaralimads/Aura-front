//
//  AuthService.swift
//  Aura
//
//  Created by Mehdi Legoullon on 15/10/2025.
//

import Foundation

class AuthService {
    static let shared = AuthService()
    private let baseURL = "http://127.0.0.1:8080/auth"
    
    // MARK: - Login
    func login(email: String, password: String) async throws -> UserLoginResponse {
        let url = URL(string: "\(baseURL)/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let loginData = UserLoginRequest(email: email, password: password)
        request.httpBody = try JSONEncoder().encode(loginData)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(UserLoginResponse.self, from: data)
    }
    
    // MARK: - Logout
    func logout() async throws {
        let url = URL(string: "\(baseURL)/logout")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(UserDefaults.standard.string(forKey: "userToken") ?? "")", forHTTPHeaderField: "Authorization")
        
        _ = try await URLSession.shared.data(for: request)
    }
}
