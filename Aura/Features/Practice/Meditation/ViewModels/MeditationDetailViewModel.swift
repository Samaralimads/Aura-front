//
//  MeditationDetailViewModel.swift
//  Aura
//
//  Created by Chabane on 01/10/2025.
//

import Foundation
import SwiftUI
import Combine

final class MeditationDetailViewModel: ObservableObject {

    @Published var remainingTime: Int
    @Published var isPlaying: Bool = false

    private var timer: Timer?
    let meditation: Meditation

    // Init
    init(meditation: Meditation) {
        self.meditation = meditation
        self.remainingTime = meditation.duration * 60
    }

    // Timer
    func togglePlay() {
        isPlaying.toggle()
        if isPlaying {
            startTimer()
            // TODO: Intégrer AVAudioPlayer ici si nécessaire
        } else {
            stopTimer()
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.remainingTime > 0 {
                self.remainingTime -= 1
            } else {
                self.stopTimer()
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func formatTime() -> String {
        let minutes = remainingTime / 60
        let seconds = remainingTime % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    // Couleur du Background
    func backgroundColor() -> Color {
        let name = meditation.image.lowercased()

        if name.contains("jaune") {
            return Color("jaune-clair")
        } else if name.contains("rose") {
            return Color("rose-clair")
        } else if name.contains("vert") {
            return Color("vert-clair")
        } else if name.contains("naranja") {
            return Color("orange-clair")
        } else if name.contains("violet") {
            return Color("violet-clair")
        } else {
            return Color("jaune-clair")
        }
    }

   // Couleur du button
    func buttonColor() -> Color {
        let name = meditation.image.lowercased()

        if name.contains("jaune") {
            return Color("jaune")
        } else if name.contains("rose") {
            return Color("rose")
        } else if name.contains("vert") {
            return Color("vert")
        } else if name.contains("orange") {
            return Color("naranja")
        } else if name.contains("violet") {
            return Color("violet")
        } else {
            return Color("jaune")
        }
    }
}
