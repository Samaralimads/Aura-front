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
    private let baseURL = URL(string: "http://127.0.0.1:8080")!
    var authToken: String?
    
    var days: [DayModel] = []
    var moods: [MoodModel] = []
    var reasons: [ReasonModel] = []
    var sleeps: [SleepModel] = []
    
    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }()
    
    func useMoods(_ moods: [MoodModel]) { self.moods = moods }
    
    // MARK: - Fetch Helpers
    private func fetch<T: Decodable>(_ endpoint: String) async -> T? {
        do {
            let url = baseURL.appending(path: endpoint)
            let (data, _) = try await URLSession.shared.data(from: url)
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Error fetching \(endpoint):", error)
            return nil
        }
    }
    
    // MARK: - Fetch Calls
    func fetchDays() async {
        guard let token = authToken?.trimmingCharacters(in: .whitespacesAndNewlines),
              !token.isEmpty else {
            print("Missing token — cannot fetch /days")
            return
        }
        
        do {
            var req = URLRequest(url: baseURL.appending(path: "days"))
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            let (data, resp) = try await URLSession.shared.data(for: req)
            
            guard let http = resp as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
                throw URLError(.badServerResponse)
            }
            
            days = try decoder.decode([DayModel].self, from: data)
            print("Loaded \(days.count) days")
        } catch {
            print("Error fetching days:", error)
        }
    }
    
    func fetchReasons() async { reasons = await fetch("reasons") ?? [] }
    func fetchSleeps()  async { sleeps  = await fetch("sleeps")  ?? [] }
    
    // MARK: - Helpers
    
    func moodIconURL(for day: DayModel) -> URL? {
        let map = Dictionary(uniqueKeysWithValues: moods.map { ($0.name.lowercased(), $0) })
        let key = day.mood.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard let model = map[key] else { return nil }
        return baseURL.appending(path: "mood").appending(path: model.image)
    }
    
    func day(for date: Date) -> DayModel? {
        let cal = Calendar.current
        return days.first { cal.isDate($0.date, inSameDayAs: date) }
    }
}
