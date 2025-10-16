//
//  Player1ViewModel.swift
//  Aura
//
//  Created by alize suchon on 26/09/2025.
//

import SwiftUI

@Observable
class BreathingPlayerViewModel {
    
    private var timer: Timer?
    var isPlaying: Bool = false
    var isFinished: Bool = false
    private var cloundsTask: Task<Void, Never>?
    
    var inhaleD: Int
    var holdD: Int
    var exhaleD: Int
    var nbOfCycles: Int
    var timeRemaining: Int
    var indexCycle: Int = 0
    var indexOrder: Int
    var audio: String
    
    var cycles: [String] = ["Inspirez","Bloquez","Expirez","Séance terminée"]
    
    init(inhaleD: Int, holdD: Int, exhaleD: Int, nbOfCycles: Int, indexOrder: Int, audio: String) {
        self.inhaleD = inhaleD
        self.holdD = holdD
        self.exhaleD = exhaleD
        self.nbOfCycles = nbOfCycles
        self.timeRemaining = (inhaleD + holdD + exhaleD) * nbOfCycles
        self.nbOfCycles = nbOfCycles
        self.indexOrder = indexOrder
        self.audio = audio
    }
     
    var Totalduration: Int {
        (inhaleD + holdD + exhaleD) * nbOfCycles
    }
    
    //Ajout vibrations
    func lightBreathingVibration() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred() //declenche la vibration
    }
    
    //Fonction pour lancer le timer + cycle (apparition du texte)
    func startBreathing() {
        var current = 0
        timer?.invalidate()
        isPlaying = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
                current += 1
                
                let cycleDuration = self.inhaleD + self.holdD + self.exhaleD
                let position = current % cycleDuration

                switch position {
                case 1: // DÉBUT INHALE
                    self.indexCycle = 0
                    self.lightBreathingVibration()
                case self.inhaleD: // DÉBUT HOLD
                    self.indexCycle = 1
                    self.lightBreathingVibration()
                case self.inhaleD + self.holdD: // DÉBUT EXHALE
                    self.indexCycle = 2
                    self.lightBreathingVibration()
                default:
                    break
                }
                
            } else {
                self.timer?.invalidate()
                self.isPlaying = false
                self.isFinished = true
                self.indexCycle = 3
            }
        }
    }
    
    //Fonction pour stopper le timer
    func stopBreathing() -> Void {
        self.timer?.invalidate()
        self.isFinished = true
        isPlaying = false
    }
}
