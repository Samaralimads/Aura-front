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
      VStack(alignment: .leading) {
            Image(meditation.image)
                .resizable()
                .scaledToFit()
                .frame(width: 204, height: 137)
                .background(Color(.systemGray6))
            Text(meditation.title)
                .font(.custom("Lexend-Medium", size: 14, relativeTo: .subheadline))
                .foregroundStyle(Color.black)
                .lineLimit(1)
          HStack {
                 Image(systemName: "clock")
                     .foregroundColor(.gray)
                 Text("\(meditation.duration) min")
                     .font(.caption)
                     .foregroundColor(.gray)
             }
        }
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
}
