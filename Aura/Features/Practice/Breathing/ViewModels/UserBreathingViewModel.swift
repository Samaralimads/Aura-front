//
//  Untitled.swift
//  Aura
//
//  Created by alize suchon on 22/10/2025.
//

import SwiftUI

//Objet userBreathing
struct UserBreathingDTO: Codable {
    let userID: UUID
    let breathingID: UUID
    let date: Date
}

@Observable
class UserBreathingViewModel {
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
        request.httpBody = try? JSONEncoder().encode(newUserBreathing)
        
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

