//
//  BreathingViewModel.swift
//  Aura
//
//  Created by alize suchon on 25/09/2025.
//

import SwiftUI

struct UserBreathingDTO: Codable {
    let userID: UUID
    let breathingID: UUID
    let date: Date
}

@Observable
final class BreathingViewModel {
    var breathings: [Breathing] = []

    func fetchBreathings() async {
        guard let url = URL(string: "http://127.0.0.1:8080/breathings") else {
            print("Error: URL not valid.")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url) //telecharge les données du backend
            let decoder = JSONDecoder()
            let decodedBreathings = try decoder.decode([Breathing].self, from: data) //Rempli le tableau Breathing avec enregistrement du JSON
      
            breathings = decodedBreathings
        } catch {
            print("Error: fetching or decoding data: \(error).")
        }
    }
    
    // MARK: - SEND DATA

    private let baseURL = "http://127.0.0.1:8080"
    
    func sendUserBreathing(userID: UUID, breathingID: UUID) async {
        guard let url = URL(string: "\(baseURL)/userBreathings") else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let newUserBreathing = UserBreathingDTO(
            userID: userID,
            breathingID: breathingID,
            date: Date()
        )
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        request.httpBody = try? encoder.encode(newUserBreathing)
        
        do {
            let (_, Response) = try await URLSession.shared.data(for: request)
            if let httpResponse = Response as? HTTPURLResponse {
                if (200...299).contains(httpResponse.statusCode) {
                    print("Success: userBreathing is created.")
                } else {
                    print("Error status code: \(httpResponse.statusCode)")
                }
            }
        } catch {
            print("Error request userBreathing: \(error.localizedDescription)")
        }
    }

}
