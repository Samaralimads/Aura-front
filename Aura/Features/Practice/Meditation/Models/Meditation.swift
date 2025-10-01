//
//  Meditation.swift
//  Aura
//
//  Created by Chabane on 01/10/2025.
//

import Foundation

enum MeditationTheme: String, CaseIterable {
    case nouveau = "Nouveau"
    case coupDeCoeur = "Coup de cœur"
    case debutant = "Débutants"
}

struct Meditation: Identifiable {
    let id: UUID
    let title: String
    let duration: Int // en minutes
    let theme: MeditationTheme
    let image: String
    let audio: String
}
