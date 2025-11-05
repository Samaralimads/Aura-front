//
//  MoodViewModel.swift
//  Aura
//
//  Created by Samara Lima da Silva on 29/09/2025.
//

import Foundation
import SwiftUI

@Observable
@MainActor

final class MoodViewModel {
    var moods: [MoodModel] = []
    
    func fetchMoods() async {
        let url = AppConfig.apiBaseURL.appendingPathComponent("/moods")

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let decodedMoods = try decoder.decode([MoodModel].self, from: data)
            
            moods = decodedMoods
        } catch {
            print("Error: fetching or decoding data: \(error).")
        }
    }
}
