//
//  DayModel.swift
//  Aura
//
//  Created by Samara Lima da Silva on 29/09/2025.
//

import Foundation

struct DayModel: Codable, Identifiable {
    var id: UUID?
    var date: Date
    var mood: String
    var emotion: String
    var sleep: String
    var reason: String
    var journal: String
}
