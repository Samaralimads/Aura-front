//
//  MeditationListByThemeView.swift
//  Aura
//
//  Created by Chabane on 20/10/2025.
//

import SwiftUI

struct MeditationListByThemeView: View {
    let theme: String
    let meditations: [Meditation]

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(meditations) { meditation in
                    NavigationLink {
                        MeditationDetailView(meditation: meditation)
                    } label: {
                        MeditationCardView(meditation: meditation)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
        .navigationTitle(theme)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
  MeditationListByThemeView(theme: "Test", meditations: [])
}