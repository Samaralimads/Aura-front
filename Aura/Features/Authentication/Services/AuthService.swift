//
//  AuthService.swift
//  Aura
//
//  Created by Mehdi Legoullon on 15/10/2025.
//

import Foundation

class AuthService {
    static let shared = AuthService()
    static let baseURL = "http://127.0.0.1:8080"
    
    // MARK: - Login
    func login(email: String, password: String) async throws -> UserLoginResponse {
        guard let url = URL(string: "\(AuthService.baseURL)/auth/login") else {
            throw APIError.unknownError
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = [
            "email": email,
            "password": password
        ]
        
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknownError
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            do {
                let errorResponse = try JSONDecoder().decode(APIErrorResponse.self, from: data)
                throw APIError.serverError(errorResponse.reason)
            } catch {
                throw error
            }
        }
        
        return try JSONDecoder().decode(UserLoginResponse.self, from: data)
    }

    // MARK: - Logout
    func logout() async throws {
        let url = URL(string: "\(AuthService.baseURL)/logout")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(
            "Bearer \(UserDefaults.standard.string(forKey: "userToken") ?? "")",
            forHTTPHeaderField: "Authorization"
        )
        
        _ = try await URLSession.shared.data(for: request)
    }
    
    // MARK: - Register
    func register(firstName: String, email: String, password: String) async throws -> UserRegisterResponse {
        let url = URL(string: "\(AuthService.baseURL)/auth/register")!
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
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknownError
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            do {
                let errorResponse = try JSONDecoder().decode(APIErrorResponse.self, from: data)
                throw APIError.serverError(errorResponse.reason)
            } catch {
                throw error
            }
        }
        
        return try JSONDecoder().decode(UserRegisterResponse.self, from: data)
    }
    
    // MARK: - Get User Profile
    func getUserProfile() async throws -> UserProfileResponse {
        guard let token = UserDefaults.standard.string(forKey: "userToken"), !token.isEmpty else {
            throw URLError(.userAuthenticationRequired)
        }
        
        guard let url = URL(string: "\(AuthService.baseURL)/users/profile") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(UserProfileResponse.self, from: data)
    }
    
    // MARK: - Update User Profile
    func update(avatar: String?, email: String?, firstName: String?, password: String?) async throws -> UserUpdateResponse {
        guard let url = URL(string: "\(AuthService.baseURL)/users/update") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = UserDefaults.standard.string(forKey: "userToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            throw URLError(.userAuthenticationRequired)
        }
        
        var body: [String: Any] = [:]
        if let avatar = avatar { body["avatar"] = avatar }
        if let email = email { body["email"] = email }
        if let firstName = firstName { body["firstName"] = firstName }
        if let password = password { body["password"] = password }
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        return try JSONDecoder().decode(UserUpdateResponse.self, from: data)
    }
    
    // MARK: - Get UserID
    func getUserID() async throws -> String {
        let profile = try await getUserProfile()
        return profile.id
    }
    
    // MARK: - Get All Avatars
    func fetchAvatars() async throws -> [Avatar] {
        guard let url = URL(string: "\(AuthService.baseURL)/avatars") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(AvatarsListResponse.self, from: data)
        
        return response.avatars.map { avatar in
            var avatar = avatar
            avatar.url = avatar.url
                .replacingOccurrences(of: "avatars/", with: "")
                .replacingOccurrences(of: "/", with: "")
            return avatar
        }
    }
    
    // MARK: - Delete Account
    func deleteAccount(userID: String) async throws {
        guard let url = URL(string: "\(AuthService.baseURL)/users/\(userID)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        if let token = UserDefaults.standard.string(forKey: "userToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            throw URLError(.userAuthenticationRequired)
        }
        
        _ = try await URLSession.shared.data(for: request)
        UserDefaults.standard.removeObject(forKey: "userToken")
    }
    
    // MARK: - Get Token
    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: "userToken")
    }
}
