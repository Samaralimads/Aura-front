//
//  MoodModel.swift
//  Aura
//
//  Created by Samara Lima da Silva on 29/09/2025.
//

import Foundation

struct MoodModel: Identifiable, Codable {
    var id: UUID?
    var name: String
    var image: String
    var color: String
}
