//
//  MeditationDetailView.swift
//  Aura
//
//  Created by Chabane on 01/10/2025.
//

import SwiftUI

struct MeditationDetailView: View {
  @StateObject private var viewModel: MeditationDetailViewModel
  @State private var floatUp: Bool = false
  @State private var shadowScale: CGFloat = 1.0

  init(meditation: Meditation) {
    _viewModel = StateObject(wrappedValue: MeditationDetailViewModel(meditation: meditation))
  }

  var body: some View {
    ZStack {
      viewModel.backgroundColor()
        .ignoresSafeArea()

      VStack(spacing: 32) {
        Spacer()

        // Timer
        Text(viewModel.formatTime())
          .font(.custom("Lexend-Medium", size: 60))
          .bold()

        Spacer()

        // Emote animé
        Image(viewModel.meditation.image)
          .resizable()
          .scaledToFit()
          .frame(height: 180)
          .offset(y: floatUp ? -10 : 30)
          .animation(
            viewModel.isPlaying ?
            Animation.easeInOut(duration: 1.8).repeatForever(autoreverses: true)
            : .default,
            value: floatUp
          )
          .onAppear {
            if viewModel.isPlaying {
              floatUp.toggle()
            }
          }
          .onChange(of: viewModel.isPlaying) { _, newValue in
            if newValue {
              withAnimation(Animation.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
                floatUp.toggle()
              }
            } else {
              withAnimation(.easeOut(duration: 0.5)) {
                floatUp = false
              }
            }
          }

        Spacer()
        
        // Ombre animée
        Image("shadow")
          .resizable()
          .scaledToFit()
          .frame(width: 140, height: 40)
          .scaleEffect(shadowScale)
          .animation(
            viewModel.isPlaying ?
            Animation.easeInOut(duration: 1.8).repeatForever(autoreverses: true)
            : .default,
            value: shadowScale
          )
          .onAppear {
            if viewModel.isPlaying {
              shadowScale = 0.7
            }
          }
          .onChange(of: viewModel.isPlaying) { _, newValue in
            if newValue {
              withAnimation(Animation.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
                shadowScale = 0.7
              }
            } else {
              withAnimation(.easeOut(duration: 0.5)) {
                shadowScale = 1.0
              }
            }
          }

        Spacer()

        // Titre de l'exercice
        Text(viewModel.meditation.title)
          .font(.custom("Lexend-Medium", size: 27))
          .padding()

        // Bouton Play/Pause
        Button(action: {
          viewModel.togglePlay()
        }) {
          ZStack {
            Circle()
              .fill(viewModel.buttonColor())
              .frame(width: 80, height: 80)
              .glassEffect()

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
}

#Preview {
  // Data pour tester la vue
  MeditationDetailView(
    meditation: Meditation(
      id: UUID(),
      title: "Méditation Name",
      duration: 2,
      theme: .coupDeCoeur,
      image: "med3",
      audio: "audio1"
    )
  )
}
