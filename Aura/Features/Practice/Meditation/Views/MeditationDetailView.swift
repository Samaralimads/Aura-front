//
//  MeditationDetailView.swift
//  Aura
//
//  Created by Chabane on 01/10/2025.
//

import SwiftUI

struct MeditationDetailView: View {

    @Environment(\.dismiss) private var dismiss // Permet de revenir à la vue précédente
    @State private var viewModel: MeditationDetailViewModel
    @State private var floatUp: Bool = false
    @State private var shadowScale: CGFloat = 1.0

    init(meditation: Meditation) {
        _viewModel = State(initialValue: MeditationDetailViewModel(meditation: meditation))
    }

    var body: some View {
        ZStack {

            // Background dynamique + shapes statiques
            viewModel.backgroundColor()
                .ignoresSafeArea()
            Image("shape1")
                .position(x: 320, y: 150)
            Image("shape2")
                .position(x: 70, y: 500)

            VStack(spacing: 32) {
                Spacer()

                // Si la méditation est terminée → message + bouton retour
                if viewModel.isFinished {
                    VStack(spacing: 20) {

                      Spacer()
                        Text("Méditation terminée")
                            .font(.custom("Lexend-Medium", size: 32))
                            .multilineTextAlignment(.center)

                        Text("Prenez un moment pour savourer ce calme intérieur.")
                            .font(.custom("Lexend-Regular", size: 18))
                            .multilineTextAlignment(.center)
                        Spacer()

                        // Bouton retour
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Retour aux méditations")
                                .font(.custom("Lexend-Medium", size: 18))
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(viewModel.buttonColor())
                                .cornerRadius(16)
                                .padding(.horizontal, 50)
                        }
                        .buttonStyle(.plain)
                    }
                    .transition(.opacity)
                    .animation(.easeInOut, value: viewModel.isFinished)
                } else {
                    // Timer
                    Text(viewModel.formatTime())
                        .font(.custom("Lexend-Medium", size: 60))
                        .bold()

                    Spacer()

                    // Emote animé
                    AsyncImage(url: URL(string: "http://127.0.0.1:8080/meditation/emote/\(viewModel.meditation.image).png")) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Color.clear
                    }
                    .frame(height: 180)
                    .offset(y: floatUp ? -10 : 30)
                    .animation(
                        viewModel.isPlaying ?
                            Animation.easeInOut(duration: 1.8).repeatForever(autoreverses: true)
                            : .default,
                        value: floatUp
                    )
                    .onAppear {
                        if viewModel.isPlaying { floatUp.toggle() }
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
                            if viewModel.isPlaying { shadowScale = 0.7 }
                        }
                        .onChange(of: viewModel.isPlaying) { _, newValue in
                            if newValue {
                                withAnimation(Animation.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) { shadowScale = 0.7 }
                            } else {
                                withAnimation(.easeOut(duration: 0.5)) { shadowScale = 1.0 }
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

                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    MeditationDetailView(
        meditation: Meditation(
            id: UUID(),
            title: "Méditation Name",
            duration: 0,
            theme: "",
            image: "jaune-emote1",
            audio: "audio-medi1.mp3",
            thumbnail: "jaune-meditation5"
        )
    )
}
