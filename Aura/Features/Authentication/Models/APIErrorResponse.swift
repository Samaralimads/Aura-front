//
//  APIErrorResponse.swift
//  Aura
//
//  Created by Mehdi Legoullon on 04/11/2025.
//

import Foundation

// MARK: - API Error Response
struct APIErrorResponse: Codable {
    let error: Bool
    let reason: String
}

enum APIError: Error {
    case serverError(String)
    case unknownError
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .serverError(let message):
            return message
        case .unknownError:
            return "Erreur inconnue."
        }
    }
}
