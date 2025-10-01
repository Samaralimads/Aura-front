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
    
    var inhaleD: Int
    var holdD: Int
    var exhaleD: Int
    var nbOfCycles: Int
    var timeRemaining: Int
    var indexCycle: Int = 0
    
    //Ajouter une phase d'intro au lieu de lancer directement l'exercice ??
    var cycles: [String] = ["Inspirez","Bloquez","Expirez"]
    
    
    init(inhaleD: Int, holdD: Int, exhaleD: Int, nbOfCycles: Int = 6) {
        self.inhaleD = inhaleD
        self.holdD = holdD
        self.exhaleD = exhaleD
        self.nbOfCycles = nbOfCycles
        self.timeRemaining = (inhaleD + holdD + exhaleD) * nbOfCycles
    }
    
    //Fonction pour gerer le cycle
    func startCycle() -> Void {
        
    }
    
    //Fonction pour lancer le timer + cycle (apparition du texte)
    func start() -> Void {
        
        var current = 0
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
                current += 1
                
                let cycleDuration = self.inhaleD + self.holdD + self.exhaleD
                let position = current % cycleDuration
                
                if position < self.inhaleD {
                    self.indexCycle = 0
                }
                else if position < self.inhaleD + self.holdD {
                    self.indexCycle = 1
                }
                else {
                    self.indexCycle = 2
                }
            } else {
                self.timer?.invalidate()
            }
        }
    }
    //Fonction pour stopper le timer
    func stop() -> Void {
        self.timer?.invalidate()
    }
}
