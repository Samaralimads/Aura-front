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
        request
            .setValue(
                "Bearer \(UserDefaults.standard.string(forKey: "userToken") ?? "")",
                forHTTPHeaderField: "Authorization"
            )
        
        _ = try await URLSession.shared.data(for: request)
    }
    
    // MARK: - Register
    func register(firstName: String, email: String, password: String) async throws -> UserRegisterResponse {
        let url = URL(string: "\(baseURL)/register")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let registerData = UserRegisterRequest(
            firstName: firstName,
            email: email,
            password: password
        )
        request.httpBody = try JSONEncoder().encode(registerData)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(UserRegisterResponse.self, from: data)
    }
    
    // MARK: - Get User Profile
    func getUserProfile() async throws -> UserProfileResponse {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            throw URLError(.userAuthenticationRequired)
        }
        
        guard let url = URL(string: "http://127.0.0.1:8080/users/profile") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(UserProfileResponse.self, from: data)
    }
    
    // MARK: - Get UserID
    func getUserID() async throws -> String {
        let profile = try await getUserProfile()
        return profile.id
    }

    // MARK: - Update User Profile
    func update(avatar: String? = nil, email: String? = nil, firstName: String? = nil, password: String? = nil) async throws -> UserUpdateResponse {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            throw URLError(.userAuthenticationRequired)
        }
        
        guard let url = URL(string: "http://127.0.0.1:8080/users/update") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let updateData = UserUpdateRequest(
            avatar: avatar,
            email: email,
            firstName: firstName,
            password: password
        )
        request.httpBody = try JSONEncoder().encode(updateData)
        
        let (data, urlResponse) = try await URLSession.shared.data(
            for: request
        )
        
        guard let httpResponse = urlResponse as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decodedResponse = try JSONDecoder().decode(
            UserUpdateResponse.self,
            from: data
        )
        
        return decodedResponse
    }
}
