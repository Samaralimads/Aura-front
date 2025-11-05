//
//  MeditationFinishedView.swift
//  Aura
//
//  Created by Chabane on 30/10/2025.
//

import SwiftUI

struct MeditationFinishedView: View {
    let buttonColor: Color
    let emoteImageName: String
    let onDismiss: () -> Void
    let onRestart: () -> Void

    var body: some View {
        VStack {
            // Texte du haut
            Text("Méditation terminée")
                .font(.custom("Lexend-Medium", size: 32))
                .multilineTextAlignment(.center)
                .padding(.top, 60)

            Spacer()

            // Emote (image) — ajouté
            AsyncImage(url: URL(string: "\(AppConfig.baseURL)/meditation/emote/\(emoteImageName).png")) { phase in
                switch phase {
                case .empty:
                    Color.clear
                        .frame(height: 180)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 180)
                case .failure:
                    // fallback si l'image ne charge pas
                    Color.clear
                        .frame(height: 180)
                @unknown default:
                    Color.clear
                        .frame(height: 180)
                }
            }
            .padding(.horizontal, 40)

            Spacer()

            // Message central
            Text("Prenez un moment pour savourer ce calme intérieur.")
                .font(.custom("Lexend-Regular", size: 18))
                .multilineTextAlignment(.center)
                .padding()

            Spacer()

            // Boutons en bas
            VStack(spacing: 16) {
                // Bouton retour
                Button(action: onDismiss) {
                    Text("Retour aux méditations")
                        .font(.custom("Lexend-Medium", size: 18))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(buttonColor)
                        .cornerRadius(16)
                }
                .buttonStyle(.plain)

                // Bouton pour recommencer la méditation
                Button(action: onRestart) {
                    Text("Refaire la méditation")
                        .font(.custom("Lexend-Medium", size: 18))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(buttonColor)
                        .cornerRadius(16)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
        .frame(maxHeight: .infinity)
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.8), value: UUID()) //
    }
}

#Preview {
    MeditationFinishedView(
      buttonColor: .jaune,
        emoteImageName: "jaune-emote1",
        onDismiss: {},
        onRestart: {}
    )
}

