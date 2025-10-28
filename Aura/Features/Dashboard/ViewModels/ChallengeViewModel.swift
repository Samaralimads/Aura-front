//
//  ChallengeModelView.swift
//  Aura
//
//  Created by alize suchon on 20/10/2025.
//

import SwiftUI

@Observable
class ChallengeViewModel {
    
    var currentChallenge: Challenge?
    var challenges: [Challenge] = []
    var tasks: [Tache] = []
    

    // MARK: - Fetch Data
    //Fonction pour recuperer tous les challenges
    func fetchChallenges() async {
        guard let url = URL(string:"http://127.0.0.1:8080/challenges") else {
            print("ERROR: url not valid")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decoder =  JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let decodedChallenge = try decoder.decode([Challenge].self, from: data)
            challenges = decodedChallenge
            
        } catch {
            print("Invalid data challenge:\(error)")
        }
    }
    
    //Fonction pour récuperer challenge du mois en cours /Pas tellement utilise ici!
    func fetchCurrentChallenge() async {
        guard let url = URL(string:"http://127.0.0.1:8080/challenges/current") else {
            print("ERROR: url not valid")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decoder =  JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let decodedChallenge = try decoder.decode(Challenge.self, from: data)
            currentChallenge = decodedChallenge
            
        } catch {
            print("Invalid data challenge:\(error)")
        }
    }
    
    //fonction pour recuperer tache via challenge ID
    func fetchTasks(id: UUID) async {
        
        guard let url = URL(string:"http://127.0.0.1:8080/tasks/challenge/\(id)")
        else {
            print("ERROR: url not valid")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedTask =  try? JSONDecoder().decode([Tache].self, from: data) {
                tasks = decodedTask
            }
            print("nombre de taches: \(tasks.count)") //log
        }
        catch {
            print("Invalid data task:\(error)")
        }
    }
}
