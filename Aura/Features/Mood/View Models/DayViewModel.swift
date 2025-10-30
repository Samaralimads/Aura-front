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

    func useMoods(_ moods: [MoodModel]) { self.moods = moods }

    func fetchDays() async {
        do {
            var req = URLRequest(url: baseURL.appending(path: "days"))
            req.httpMethod = "GET"

            if let rawToken = authToken?.trimmingCharacters(in: .whitespacesAndNewlines),
               !rawToken.isEmpty {
                print("Attaching Authorization header:", "Bearer \(rawToken.prefix(12))...")
                req.setValue("Bearer \(rawToken)", forHTTPHeaderField: "Authorization")
            } else {
                print("No valid token to attach")
            }

            let (data, resp) = try await URLSession.shared.data(for: req)
            if let http = resp as? HTTPURLResponse {
                print("GET /days status:", http.statusCode)
            }

            guard let http = resp as? HTTPURLResponse,
                  (200..<300).contains(http.statusCode) else {
                throw URLError(.badServerResponse)
            }

            let dec = JSONDecoder()
            dec.dateDecodingStrategy = .iso8601
            days = try dec.decode([DayModel].self, from: data)
            print("Decoded \(days.count) days from server")
        } catch {
            print("Erreur fetch/decode:", error)
        }
    }


        func fetchReasons() async {
            do {
                let url = baseURL.appending(path: "reasons")
                let (data, _) = try await URLSession.shared.data(from: url)
                reasons = try JSONDecoder().decode([ReasonModel].self, from: data)
            } catch { print("Error fetching/decoding reasons:", error) }
        }

        func fetchSleeps() async {
            do {
                let url = baseURL.appending(path: "sleeps")
                let (data, _) = try await URLSession.shared.data(from: url)
                sleeps = try JSONDecoder().decode([SleepModel].self, from: data)
            } catch { print("Error fetching/decoding sleeps:", error) }
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
    
//    func updateDay(
//            dayID: UUID,
//            moodID: UUID?,
//            emotionID: UUID?,
//            sleepID: UUID?,
//            reasonID: UUID?,
//            journalID: UUID?
//        ) async throws -> DayModel {
//           
//            guard let token = authToken, !token.isEmpty else {
//                   throw URLError(.userAuthenticationRequired)
//               }
//            
//            guard let url = URL(string: "\(baseURL)/days/\(dayID)") else {
//                throw URLError(.badURL)
//            }
//            
//            var request = URLRequest(url: url)
//            request.httpMethod = "PATCH"
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//            
//            let body: [String: Any?] = [
//                "moodID": moodID?.uuidString,
//                "emotionID": emotionID?.uuidString,
//                "sleepID": sleepID?.uuidString,
//                "reasonID": reasonID?.uuidString,
//                "journalID": journalID?.uuidString
//            ].compactMapValues { $0 }
//            
//            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
//            
//            let (data, response) = try await URLSession.shared.data(for: request)
//            
//            guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
//                throw URLError(.badServerResponse)
//            }
//            
//            let updatedDay = try JSONDecoder().decode(DayModel.self, from: data)
//            return updatedDay
//        }
}
