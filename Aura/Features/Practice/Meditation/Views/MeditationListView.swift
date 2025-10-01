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

    var body: some View {
        List(meditations) { meditation in
            NavigationLink {
                MeditationDetailView(meditation: meditation)
            } label: {
                HStack {
                    Image(meditation.image)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .cornerRadius(8)
                    VStack(alignment: .leading) {
                        Text(meditation.title)
                        Text("\(meditation.duration) min")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .navigationTitle(title)
    }
}

#Preview {
    NavigationView {
        MeditationListView(
            title: "Nouveau",
            meditations: [
                Meditation(id: UUID(), title: "Méditation 1", duration: 30, theme: .nouveau, image: "med1", audio: "audio1"),
                Meditation(id: UUID(), title: "Méditation 2", duration: 20, theme: .nouveau, image: "med2", audio: "audio2")
            ]
        )
    }
}
