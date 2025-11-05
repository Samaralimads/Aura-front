//
//  AppConfig.swift
//  Aura
//
//  Created by Mehdi Legoullon on 05/11/2025.
//

import Foundation

enum AppEnvironment {
    case dev
    
    var baseURL: String {
        switch self {
        case .dev: return "http://127.0.0.1:8080"
        }
    }
}

enum AppConfig {
    static let environment: AppEnvironment = .dev
    static let baseURL: String = environment.baseURL
    static let apiBaseURL: URL = URL(string: baseURL)!
}
