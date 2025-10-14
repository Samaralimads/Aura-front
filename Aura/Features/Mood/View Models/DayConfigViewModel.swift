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
    
    
    // MARK: - Decoded data from my db goes here
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

    func fetchMoods() async {
        guard let url = URL(string: "\(baseURL)/moods") else { print("Bad URL"); return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            moods = try JSONDecoder().decode([MoodModel].self, from: data)
        } catch {
            print("Error fetching/decoding moods: \(error)")
        }
    }
    
    func fetchEmotions() async {
        guard let url = URL(string: "\(baseURL)/emotions") else { print("Bad URL"); return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            emotions = try JSONDecoder().decode([EmotionModel].self, from: data)
        } catch {
            print("Error fetching/decoding emotions: \(error)")
        }
    }
    
    func fetchSleeps() async {
        guard let url = URL(string: "\(baseURL)/sleeps") else { print("Bad URL"); return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            sleeps = try JSONDecoder().decode([SleepModel].self, from: data)
        } catch {
            print("Error fetching/decoding sleeps: \(error)")
        }
    }
    
    func fetchReasons() async {
        guard let url = URL(string: "\(baseURL)/reasons") else { print("Bad URL"); return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            reasons = try JSONDecoder().decode([ReasonModel].self, from: data)
        } catch {
            print("Error fetching/decoding reasons: \(error)")
        }
    }
    
    func fetchJournals() async {
        guard let url = URL(string: "\(baseURL)/journals") else { print("Bad URL"); return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            journals = try JSONDecoder().decode([JournalModel].self, from: data)
        } catch {
            print("Error fetching/decoding journals: \(error)")
        }
    }
    
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
        

        if let token = authToken, !token.isEmpty {
            req.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
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
