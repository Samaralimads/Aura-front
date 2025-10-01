//
//  EmotionViewModel.swift
//  Aura
//
//  Created by Samara Lima da Silva on 29/09/2025.
//

import Foundation
import SwiftUI

@Observable
final class EmotionViewModel {
    var emotions: [EmotionModel] = []
    
    func fetchEmotions() async {
        guard let url = URL(string: "http://127.0.0.1:8080/emotions") else {
            print("Bad URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let decodedEmotions = try decoder.decode([EmotionModel].self, from: data)
            
            emotions = decodedEmotions
        } catch {
            print("Error: fetching or decoding data: \(error).")
        }
    }
}
