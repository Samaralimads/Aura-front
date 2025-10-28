//
//  BreathingViewModel.swift
//  Aura
//
//  Created by alize suchon on 25/09/2025.
//

import SwiftUI

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
}
