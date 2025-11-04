//
//  DayConfigViewModel.swift
//  Aura
//
//  Created by Samara Lima da Silva on 01/10/2025.
//

import Foundation
import SwiftUI

@Observable
@MainActor

final class DayConfigViewModel {
    
    private let baseURL = "http://127.0.0.1:8080"
    var authToken: String?
    
    
    // MARK: - Decoded data from my db
    var moods: [MoodModel] = []
    var emotions: [EmotionModel] = []
    var sleeps: [SleepModel] = []
    var reasons: [ReasonModel] = []
    var journals: [JournalModel] = []
    
    
    // MARK: - Hide "Void"
    
    var displayEmotions: [EmotionModel] { emotions.filter { $0.name != "Void" } }
    var displayReasons:  [ReasonModel]  { reasons.filter  { $0.name != "Void" } }
    var displaySleeps:   [SleepModel]   { sleeps.filter   { $0.name != "Void" } }
    var displayMoods:    [MoodModel]    { moods.filter    { $0.name != "Void" } }
    
    func emotions(for moodID: UUID?) -> [EmotionModel] {
        let nonVoid = emotions.filter { $0.name.trimmingCharacters(in: .whitespacesAndNewlines) != "Void" }
        guard let moodID else { return nonVoid }
        return nonVoid.filter { $0.moodID == moodID }
    }
    
    // MARK: - Fetching functions
    
    private func fetch<T: Decodable>(_ endpoint: String, as type: T.Type) async -> T? {
        guard let url = URL(string: "\(baseURL)/\(endpoint)") else {
            print("Bad URL for \(endpoint)")
            return nil
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Error fetching \(endpoint):", error)
            return nil
        }
    }
    
    
    func fetchMoods() async { moods = await fetch("moods", as: [MoodModel].self) ?? [] }
    
    func fetchEmotions() async { emotions = await fetch("emotions", as: [EmotionModel].self) ?? [] }
    
    func fetchSleeps() async { sleeps = await fetch("sleeps", as: [SleepModel].self) ?? [] }
    
    func fetchReasons() async { reasons = await fetch("reasons", as: [ReasonModel].self) ?? [] }
    
    func fetchJournals() async { journals = await fetch("journals", as: [JournalModel].self) ?? [] }
    
    
    func fetchAll() async {
        await fetchMoods()
        await fetchEmotions()
        await fetchSleeps()
        await fetchReasons()
        await fetchJournals()
    }
    
}


// MARK: - DTOs for client → server
struct DayCreateDTO: Encodable {
    let date: Date
    let moodID: UUID?
    let emotionID: UUID?
    let sleepID: UUID?
    let reasonID: UUID?
    let journalID: UUID?
}
struct DayResponseDTO: Decodable {
    let id: UUID?
    let date: Date
    let mood: String
    let emotion: String
    let sleep: String
    let reason: String
    let journal: String
}

private struct JournalCreateDTO: Encodable { let field: String }
private struct JournalResponseDTO: Decodable { let id: UUID; let field: String }

// MARK: - Save helpers
extension DayConfigViewModel {
    func journalID(forNote text: String) async throws -> UUID? {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        return try await createJournal(field: trimmed)
    }
    
    private func createJournal(field: String) async throws -> UUID {
        guard let url = URL(string: "\(baseURL)/journals") else { throw URLError(.badURL) }
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try JSONEncoder().encode(JournalCreateDTO(field: field))
        
        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        let created = try JSONDecoder().decode(JournalResponseDTO.self, from: data)
        return created.id
    }
    
    
    func createDay(
        date: Date = Date(),
        moodID: UUID?,
        emotionID: UUID?,
        sleepID: UUID?,
        reasonID: UUID?,
        noteText: String
    ) async throws -> DayResponseDTO {
        let journalID = try await journalID(forNote: noteText)
        
        guard let url = URL(string: "\(baseURL)/days") else { throw URLError(.badURL) }
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        guard let token = authToken, !token.isEmpty else {
            throw URLError(.userAuthenticationRequired)
        }
        req.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        req.httpBody = try encoder.encode(DayCreateDTO(
            date: date,
            moodID: moodID,
            emotionID: emotionID,
            sleepID: sleepID,
            reasonID: reasonID,
            journalID: journalID
        ))
        
        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(DayResponseDTO.self, from: data)
    }
}
