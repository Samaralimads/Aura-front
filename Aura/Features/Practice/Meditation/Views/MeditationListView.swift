//
//  MeditationListView.swift
//  Aura
//
//  Created by Chabane on 01/10/2025.
//

import SwiftUI

struct MeditationListView: View {
    let title: String
    let meditations: [Meditation]

    // Deux colonnes flexibles
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(meditations) { meditation in
                    NavigationLink {
                        MeditationDetailView(meditation: meditation)
                    } label: {
                        MeditationCardView(meditation: meditation)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .navigationTitle(title)
    }
}

#Preview {
    NavigationView {
        MeditationListView(
            title: "Nouveau",
            meditations: [
                Meditation(id: UUID(), title: "Méditation 1", duration: 3, theme: .nouveau, image: "med1", audio: "audio1"),
                Meditation(id: UUID(), title: "Méditation 2", duration: 1, theme: .nouveau, image: "med2", audio: "audio2"),
                Meditation(id: UUID(), title: "Méditation 3", duration: 4, theme: .nouveau, image: "med1", audio: "audio3"),
                Meditation(id: UUID(), title: "Méditation 4", duration: 6, theme: .nouveau, image: "med2", audio: "audio4")
            ]
        )
    }
}
