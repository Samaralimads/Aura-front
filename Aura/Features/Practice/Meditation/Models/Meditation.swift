//
//  Meditation.swift
//  Aura
//
//  Created by Chabane on 01/10/2025.
//

import Foundation

struct Meditation: Identifiable, Codable {
    let id: UUID
    let title: String
    let duration: Int
    let theme: String
    let image: String
    let audio: String
    let thumbnail: String
}
