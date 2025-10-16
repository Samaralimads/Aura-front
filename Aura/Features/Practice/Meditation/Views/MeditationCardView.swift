//
//  MeditationCardView.swift
//  Aura
//
//  Created by Chabane on 01/10/2025.
//

import SwiftUI

struct MeditationCardView: View {
    let meditation: Meditation

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Image en haut
            Image(meditation.image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .frame(height: 130)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 13))

            // Titre
            Text(meditation.title)
                .font(.custom("Lexend-Medium", size: 14, relativeTo: .subheadline))
                .foregroundStyle(Color.black)
                .lineLimit(1)

            // Durée
            HStack(spacing: 4) {
                Image(systemName: "clock")
                    .foregroundColor(.gray)
                Text("\(meditation.duration) min")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(6)
        .cornerRadius(13)
    }
}

#Preview {
    MeditationCardView(
        meditation: Meditation(
            id: UUID(),
            title: "Méditation Relax",
            duration: 30,
            theme: .coupDeCoeur,
            image: "med1",
            audio: "audio1"
        )
    )
    .frame(width: 180)
    .padding()
}
