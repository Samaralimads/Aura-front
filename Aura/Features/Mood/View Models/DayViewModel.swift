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

    func useMoods(_ moods: [MoodModel]) { self.moods = moods }

    func fetchDays() async {
        do {
            var req = URLRequest(url: baseURL.appending(path: "days"))
            req.httpMethod = "GET"
            if let t = authToken, !t.isEmpty {
                req.addValue("Bearer \(t)", forHTTPHeaderField: "Authorization")
            }
            let (data, _) = try await URLSession.shared.data(for: req)
            let dec = JSONDecoder(); dec.dateDecodingStrategy = .iso8601
            days = try dec.decode([DayModel].self, from: data)
        } catch {
            print("Error fetching/decoding days:", error)
        }
    }

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
