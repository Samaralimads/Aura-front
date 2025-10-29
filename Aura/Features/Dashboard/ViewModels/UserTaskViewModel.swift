//
//  UserTaskViewModel.swift
//  Aura
//
//  Created by alize suchon on 28/10/2025.
//

import SwiftUI

struct UserTask : Codable{
    let userID : UUID
    let taskID : UUID
}

@Observable
class UserTaskViewModel {
    
    private let baseURL = "http://127.0.0.1:8080"
    
    func sendUserTask(userID : UUID, taskID : UUID) async {
        guard let url = URL(string: "\(baseURL)/userTasks") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let userTask = UserTask(userID: userID, taskID: taskID)
        request.httpBody = try? JSONEncoder().encode(userTask)
        
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
