//
//  SleepViewModel.swift
//  Aura
//
//  Created by Samara Lima da Silva on 29/09/2025.
//

import Foundation
import SwiftUI

@Observable
final class SleepViewModel {
    var sleeps: [SleepModel] = []
    
    func fetchSleeps() async {
        guard let url = URL(string: "http://127.0.0.1:8080/reasons") else {
            print("Bad URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let decodedSleeps = try decoder.decode([SleepModel].self, from: data)
            
            sleeps = decodedSleeps
        } catch {
            print("Error: fetching or decoding data: \(error).")
        }
    }
}
