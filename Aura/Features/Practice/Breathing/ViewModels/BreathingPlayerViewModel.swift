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
   // private let soundPlayer = MusicManager()
    
    var scale: CGFloat = 0.9
    
    private var moonTask: Task<Void, Never>?
    private var cloundsTask: Task<Void, Never>?
    
    var phase: Phase = .inhale
        
    var inhaleD: Int
    var holdD: Int
    var exhaleD: Int
    var nbOfCycles: Int
    var timeRemaining: Int
    var indexCycle: Int = 0
    var indexOrder: Int
    
    var isPlaying: Bool = false
    
    var cycles: [String] = ["Inspirez","Bloquez","Expirez"]
    
    enum Phase {
        case inhale, hold, exhale
    }
    
    init(inhaleD: Int, holdD: Int, exhaleD: Int, nbOfCycles: Int, indexOrder: Int) {
        self.inhaleD = inhaleD
        self.holdD = holdD
        self.exhaleD = exhaleD
        self.nbOfCycles = nbOfCycles
        self.timeRemaining = (inhaleD + holdD + exhaleD) * nbOfCycles
        self.nbOfCycles = nbOfCycles
        self.indexOrder = indexOrder
        //self.cloudViewModel = cloudViewModel
    }
     
    var Totalduration: Int {
        (inhaleD + holdD + exhaleD) * nbOfCycles
    }
    
    //Ajout vibration à chaque phases
    func lightBreathingVibration() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred() //declenche la vibration
    }
    
    //Fonction pour lancer le timer + cycle (apparition du texte)
    func startBreathing() -> Void {
        
        var current = 0
        timer?.invalidate()
        isPlaying = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
                current += 1
                
                let cycleDuration = self.inhaleD + self.holdD + self.exhaleD
                let position = current % cycleDuration
                print("\(position)")

                switch position {
                case 1: // début inhale
                    self.indexCycle = 0
                    self.lightBreathingVibration()
                   // self.phase = .inhale
                   // self.soundPlayer.playSound(named: "ting")
                case self.inhaleD: // début hold
                    self.indexCycle = 1
                    self.lightBreathingVibration()
                    //self.phase = .hold
                  //  self.soundPlayer.playSound(named: "ting")
                case self.inhaleD + self.holdD: // début exhale
                    self.indexCycle = 2
                    self.lightBreathingVibration()
                    //self.phase = .exhale
                   // self.soundPlayer.playSound(named: "ting")
                default:
                    break
                }
                
            } else {
                self.timer?.invalidate()
               // self.soundPlayer.pauseSound()
            }
        }
    }
    
    //Animate moon view
    func MoonAnimStart() -> Void {
        moonTask = Task {
            while isPlaying {
                withAnimation(.easeInOut(duration: Double(2))) {
                    // Inhale
                    scale = 1.15
                }
                try? await Task.sleep(for: .seconds(inhaleD))
                //Hold
                try? await Task.sleep(for: .seconds(holdD))
                //Exhale
                withAnimation(Animation.easeInOut(duration: Double(2))) {
                    scale = 0.9
                }
                try? await Task.sleep(for: .seconds(exhaleD))
            }
        }
    }
    
    //Animate clounds for SunAnimationView
//    func CloudAnimStart() -> Void {
//        let screen = UIScreen.main.bounds.width
//        cloundsTask = Task {
//            while isPlaying {
//                withAnimation(Animation.easeInOut(duration: Double(2))) {
//                    // Inhale
//                    for cloud in cloudViewModel.cloudsArray {
//                        cloud.moveToX(x:-cloud.width)
//                    }
//                }
//                try? await Task.sleep(for: .seconds(inhaleD))
//                //Hold
//                try? await Task.sleep(for: .seconds(holdD))
//                
//                //Exhale
//                withAnimation(Animation.easeInOut(duration:Double(2))) {
//                    for cloud in cloudViewModel.cloudsArray {
//                        cloud.moveToX(x:screen/2)
//                    }
//                }
//                try? await Task.sleep(for: .seconds(exhaleD))
//            }
//        }
//    }
    
    //Fonction pour stopper le timer
    func stopBreathing() -> Void {
        self.timer?.invalidate()
        isPlaying = false
        moonTask?.cancel()
        moonTask = nil
        //cloundsTask?.cancel()
        //cloundsTask = nil
        //self.soundPlayer.stopSound()
    }
}
