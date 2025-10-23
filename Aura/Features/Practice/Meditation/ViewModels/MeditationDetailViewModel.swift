//
//  MeditationDetailViewModel.swift
//  Aura
//
//  Created by Chabane on 01/10/2025.
//

import Foundation
import SwiftUI
import AVFoundation
import Observation

@Observable
final class MeditationDetailViewModel {
    var remainingTime: Int
    var isPlaying: Bool = false
    var isFinished: Bool = false // Indique si la méditation est terminée

    private var timer: Timer?
    private var audioPlayer: AVPlayer?
    let meditation: Meditation

    // Init
    init(meditation: Meditation) {
        self.meditation = meditation
        self.remainingTime = meditation.duration * 60
    }

    // Timer
    func togglePlay() {
        // Ne rien faire si la méditation est terminée
        if isFinished { return }

        isPlaying.toggle()
        if isPlaying {
            startTimer()
            playAudio()
        } else {
            stopTimer()
            pauseAudio()
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] _ in
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                stopTimer()
                stopAudio()
                isPlaying = false
                isFinished = true // Marque la fin de la méditation
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    // Lecture audio depuis le backend
    private func playAudio() {
        let baseURL = "http://127.0.0.1:8080/"
        let audioPath = "meditation/audio/" + meditation.audio
        guard let url = URL(string: baseURL + audioPath) else { return }

        let playerItem = AVPlayerItem(url: url)
        audioPlayer = AVPlayer(playerItem: playerItem)
        audioPlayer?.play()
    }

    private func pauseAudio() {
        audioPlayer?.pause()
    }

    private func stopAudio() {
        audioPlayer?.pause()
        audioPlayer?.seek(to: .zero)
        audioPlayer = nil
    }

    func formatTime() -> String {
        let minutes = remainingTime / 60
        let seconds = remainingTime % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    // Couleur du Background
    func backgroundColor() -> Color {
        let name = meditation.image.lowercased()
        if name.contains("jaune") { return Color("jaune-clair") }
        if name.contains("rose") { return Color("rose-clair") }
        if name.contains("vert") { return Color("vert-clair") }
        if name.contains("orange") { return Color("orange-clair") }
        if name.contains("violet") { return Color("violet-clair") }
        return Color("jaune-clair")
    }

    // Couleur du button
    func buttonColor() -> Color {
        let name = meditation.image.lowercased()
        if name.contains("jaune") { return Color("jaune") }
        if name.contains("rose") { return Color("rose") }
        if name.contains("vert") { return Color("vert") }
        if name.contains("orange") { return Color("naranja") }
        if name.contains("violet") { return Color("violet") }
        return Color("jaune")
    }
}
