//
//  AppState.swift
//  Aura
//
//  Created by Mehdi Legoullon on 20/10/2025.
//

import SwiftUI
import Foundation
import Observation

enum HumeurRoute: Hashable {
    case mood
    case configureDay(moodID: UUID?, moodColorName: String?)
}

@Observable
final class AppState {
    var token: String? {
        UserDefaults.standard.string(forKey: "userToken")
    }
    var selectedTab: Int = 0
    var humeurPath = NavigationPath() 
    var refreshDaysTrigger = UUID()
    
    
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
}
