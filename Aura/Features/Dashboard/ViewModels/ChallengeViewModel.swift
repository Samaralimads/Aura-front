//
//  ChallengeModelView.swift
//  Aura
//
//  Created by alize suchon on 20/10/2025.
//

import SwiftUI

struct UserTaskDTO : Codable{
    let userID : UUID
    let taskID : UUID
}

struct UserChallengeDTO : Codable{
    let userID : UUID
    let challengeID : UUID
}

@Observable
class ChallengeViewModel {
    
    var currentChallenge: Challenge?
    var challenges: [Challenge] = []
    var tasks: [Tache] = []
    

    // MARK: - Fetch Data
    //Fonction pour recuperer tous les challenges
    func fetchChallenges() async {

        let url = AppConfig.apiBaseURL.appendingPathComponent("/challenges")

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
        
        let url = AppConfig.apiBaseURL.appendingPathComponent("/challenges/current")

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
        
        let url = AppConfig.apiBaseURL.appendingPathComponent("tasks/challenge/\(id)")

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
    
    // MARK: - SEND DATA
    func sendUserTask(userID : UUID, taskID : UUID) async {
        let url = AppConfig.apiBaseURL.appendingPathComponent("/userTasks")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let newUserTask = UserTaskDTO(userID: userID, taskID: taskID)
        request.httpBody = try? JSONEncoder().encode(newUserTask)
        
        do {
            let( _, response) = try await URLSession.shared.data(for: request)
            if let response = response as? HTTPURLResponse {
                if (200...299).contains(response.statusCode) {
                    print("Succes: UserTask created")
                } else {
                    print("Error: UserTask not created \(response.statusCode)")
                }
            }
        } catch {
            print("Error request UserTask table : \(error.localizedDescription)")
        }
    }
    
    func sendUserChallenge(userID : UUID, challengeID : UUID) async {
        let url = AppConfig.apiBaseURL.appendingPathComponent("/userChallenges")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let newUserChallenge = UserChallengeDTO(userID: userID, challengeID: challengeID)
        request.httpBody = try? JSONEncoder().encode(newUserChallenge)
        
        do {
            let( _, response) = try await URLSession.shared.data(for: request)
            if let response = response as? HTTPURLResponse {
                if (200...299).contains(response.statusCode) {
                    print("Succes: UserTask created")
                } else {
                    print("Error: UserTask not created \(response.statusCode)")
                }
            }
        } catch {
            print("Error request UserTask table : \(error.localizedDescription)")
        }
    }
}
