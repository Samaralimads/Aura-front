//
//  DayViewModel.swift
//  Aura
//
//  Created by Samara Lima da Silva on 02/10/2025.
//

import Foundation
import SwiftUI

@Observable
@MainActor
final class DayViewModel {
    
    private let baseURL = "http://127.0.0.1:8080"
    var authToken: String?
    
    var days: [DayModel] = []
    
    func fetchDays() async {
        guard let url = URL(string: "\(baseURL)/days") else {
            print("Bad URL"); return
        }
        
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        if let t = authToken, !t.isEmpty {
            req.addValue("Bearer \(t)", forHTTPHeaderField: "Authorization")
        }
        do {
            let (data, _) = try await URLSession.shared.data(for: req)
            let dec = JSONDecoder()
            dec.dateDecodingStrategy = .iso8601
            days = try dec.decode([DayModel].self, from: data)
        } catch {
            print("Error fetching/decoding days: \(error)")
        }
    }
}
