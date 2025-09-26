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
        guard let url = URL(string: "http://192.168.1.128:8080/breathings") else {
            print("Error: URL not valid.")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url) //telecharge les données du backend
            let decoder = JSONDecoder()
           // decoder.keyDecodingStrategy = .convertFromSnakeCase
            var decodedBreathings = try decoder.decode([Breathing].self, from: data) //Rempli le tableau Breathing avec enregistrement du JSON

            let animations: [AnimationType] = [.wave, .montain, .sun, .moon] //tableau d'animation ajouté en dur
            for i in decodedBreathings.indices {
                decodedBreathings[i].animation = animations[i]
            }
                    
            breathings = decodedBreathings
        } catch {
            print("Error fetching or decoding data: \(error)")
        }
    }
}
