//
//  MeditationCardView.swift
//  Aura
//
//  Created by Chabane on 20/10/2025.
//

import SwiftUI

struct MeditationCardView: View {
    let meditation: Meditation

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Miniature
            AsyncImage(url: URL(string: "http://127.0.0.1:8080/meditation/thumbnail/\(meditation.thumbnail).png")) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray
            }
            .frame(height: 120)
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            // Titre
            Text(meditation.title)
                .font(.custom("Lexend-Medium", size: 14))
                .lineLimit(1)
                .foregroundStyle(.black)

            // Durée
            Text("\(meditation.duration) min")
                .font(.system(size: 12))
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
