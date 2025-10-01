//
//  MeditationViewModel.swift
//  Aura
//
//  Created by Chabane on 01/10/2025.
//

import Foundation

class MeditationViewModel: ObservableObject {
    @Published var meditations: [Meditation] = []

    init() {
        loadMockData()
    }

    func loadMockData() {
        self.meditations = [
            Meditation(id: UUID(), title: "Méditation 1", duration: 30, theme: .nouveau, image: "med1", audio: "audio1"),
            Meditation(id: UUID(), title: "Méditation 2", duration: 30, theme: .nouveau, image: "med2", audio: "audio2"),
            Meditation(id: UUID(), title: "Méditation Relax", duration: 30, theme: .coupDeCoeur, image: "med3", audio: "audio3"),
            Meditation(id: UUID(), title: "Débutant Zen", duration: 30, theme: .debutant, image: "med4", audio: "audio4")
        ]
    }

    func meditations(for theme: MeditationTheme) -> [Meditation] {
        meditations.filter { $0.theme == theme }
    }
}
