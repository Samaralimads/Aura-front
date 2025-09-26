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
    var timeRemaining: Int
    
    init(duration: Int){
        self.timeRemaining = duration
    }
    
    //Fonction pour lancer le timer
    func start() -> Void {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            }
            else {
                self.timer?.invalidate()
            }
        }
    }
    //Fonction pour stopper le timer
    func stop() -> Void {
        self.timer?.invalidate()
    }
}
