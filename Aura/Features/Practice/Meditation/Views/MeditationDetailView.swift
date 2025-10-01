//
//  MeditationDetailView.swift
//  Aura
//
//  Created by Chabane on 01/10/2025.
//

import SwiftUI

struct MeditationDetailView: View {
    @StateObject private var viewModel: MeditationDetailViewModel

    init(meditation: Meditation) {
        _viewModel = StateObject(wrappedValue: MeditationDetailViewModel(meditation: meditation))
    }

    var body: some View {
        VStack(spacing: 32) {
            // Timer
            Text(viewModel.formatTime())
            .font(.custom("Lexend-Medium", size: 60))
                .bold()

            // Image
            Image(viewModel.meditation.image)
                .resizable()
                .scaledToFit()
                .frame(height: 180)

            // Titre
            Text(viewModel.meditation.title)
                .font(.custom("Lexend-Medium", size: 27))
                .padding()

            // Bouton Play/Pause
            Button(action: {
                viewModel.togglePlay()
            }) {
                ZStack {
                    // Fond du bouton
                    Circle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: 80, height: 80)
                        .glassEffect()

                    // Icône
                    Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.black)
                }
            }
            .buttonStyle(.plain)
        }
        .padding()
    }
}

#Preview {
    MeditationDetailView(
        meditation: Meditation(
            id: UUID(),
            title: "Méditation Relax",
            duration: 2,
            theme: .coupDeCoeur,
            image: "med3",
            audio: "audio1"
        )
    )
}
