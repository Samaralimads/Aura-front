//
//  MeditationDetailViewModel.swift
//  Aura
//
//  Created by Chabane on 01/10/2025.
//

import Foundation
import Combine

class MeditationDetailViewModel: ObservableObject {
    @Published var remainingTime: Int
    @Published var isPlaying: Bool = false

    private var timer: Timer?
    let meditation: Meditation

    init(meditation: Meditation) {
        self.meditation = meditation
        self.remainingTime = meditation.duration * 60
    }

    func togglePlay() {
        isPlaying.toggle()
        if isPlaying {
            startTimer()
            // TODO: Intégrer AVAudioPlayer pour la lecture audio
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
}
