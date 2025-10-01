//
//  JournalViewModel.swift
//  Aura
//
//  Created by Samara Lima da Silva on 29/09/2025.
//

import Foundation
import SwiftUI

@Observable
final class JournalViewModel {
    var journals: [JournalModel] = []
    
    func fetchJournals() async {
        guard let url = URL(string: "http://127.0.0.1:8080/journals") else {
            print("Bad URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let decodedJournals = try decoder.decode([JournalModel].self, from: data)
            
            journals = decodedJournals
        } catch {
            print("Error: fetching or decoding data: \(error).")
        }
    }
}
