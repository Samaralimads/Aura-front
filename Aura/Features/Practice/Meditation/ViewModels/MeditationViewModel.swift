//
//  MeditationViewModel.swift
//  Aura
//
//  Created by Chabane on 01/10/2025.
//

import Foundation
import Observation

@MainActor
@Observable
final class MeditationViewModel {
    var meditations: [Meditation] = []
    var isLoading: Bool = false
    var errorMessage: String?

    // Ordre manuel des thèmes sur la vue MeditationView
    let themeOrder: [String] = [
        "Nouveau",
        "Coup de Coeur",
        "Débutants",
        "Éveil doux",
        "Énergie et equilibre",
    ]

    init() {
        // Démarrer le chargement automatiquement
        Task {
            await fetchMeditations()
        }
    }

    // Appel de l'API
    func fetchMeditations() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        guard let url = URL(string: "http://127.0.0.1:8080/meditations") else {
            errorMessage = "URL non valide"
            print("Error: URL not valid.")
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                errorMessage = "Erreur serveur"
                throw URLError(.badServerResponse)
            }

            let decoder = JSONDecoder()
            let decodedMeditations = try decoder.decode([Meditation].self, from: data)
            self.meditations = decodedMeditations

            print("\(decodedMeditations.count) méditations chargées depuis le backend.")
        } catch {
            errorMessage = "Erreur de chargement des méditations."
            print("Erreur fetch/decode: \(error.localizedDescription)")
        }
    }

    func groupedByTheme() -> [String: [Meditation]] {
        Dictionary(grouping: meditations, by: { $0.theme })
    }

  // Envoi vers le backend (User)

  struct UserMeditationDTO: Codable {
      let userID: UUID
      let meditationID: UUID
      let date: Date
  }

  private let baseURL = "http://127.0.0.1:8080"

  func sendUserMeditation(userID: UUID, meditationID: UUID) async {
    guard let url = URL(string: "\(baseURL)/user/meditations") else {return}

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")


    let newUserMeditation = UserMeditationDTO(
      userID: userID,
      meditationID: meditationID,
      date: Date()
    )

    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    request.httpBody = try? encoder.encode(newUserMeditation)

    do {
      let (_, Response) = try await URLSession.shared.data(for: request)
      if let httpResponse = Response as? HTTPURLResponse {
        if (200...299).contains(httpResponse.statusCode) {
          print("Success: userMeditation is created.")
        } else {
          print("Error status code: \(httpResponse.statusCode)")
        }
      }
    } catch {
      print("Error request userMeditation: \(error.localizedDescription)")
    }
  }

}
