//
//  AppState.swift
//  Aura
//
//  Created by Mehdi Legoullon on 20/10/2025.
//

import Foundation
import Observation

@Observable
final class AppState {
    private(set) var isLoggedIn: Bool = UserDefaults.standard.string(forKey: "userToken") != nil
    private(set) var userProfile: UserProfileResponse?
    private(set) var isLoading: Bool = false
    private(set) var error: Error?
    
    private let authService = AuthService.shared
    
    init() {
        if isLoggedIn {
            Task { await loadUserProfile() }
        }
    }
    
    func login(email: String, password: String) async throws {
        isLoading = true
        defer { isLoading = false }
        do {
            let response = try await authService.login(email: email, password: password)
            UserDefaults.standard.set(response.token, forKey: "userToken")
            isLoggedIn = true
            await loadUserProfile()
        } catch {
            self.error = error
            throw error
        }
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "userToken")
        isLoggedIn = false
        userProfile = nil
    }
    
    func loadUserProfile() async {
        guard isLoggedIn else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            userProfile = try await authService.getUserProfile()
        } catch {
            self.error = error
        }
    }
    
    var token: String? {
        UserDefaults.standard.string(forKey: "userToken")
    }
}
