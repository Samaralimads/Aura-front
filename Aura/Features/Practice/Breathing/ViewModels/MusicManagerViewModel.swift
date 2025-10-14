//
//  MusicManagerModelView.swift
//  Aura
//
//  Created by alize suchon on 02/10/2025.
//

import AVFoundation

class MusicManager {
    
    private var player: AVAudioPlayer?
    
    //MARK: FONCTION PLAY MUSIC
    func playSound(named name: String) {
        if let url = Bundle.main.url(forResource: name, withExtension: "mp3") {
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.prepareToPlay() // Précharge le son
                player?.play()
            } catch {
                print("Erreur : \(error)")
            }
        } else {
            print("Fichier audio \(name).mp3 non trouvé")
        }
    }
    
    func pauseSound() {
        player?.pause()
    }
    
    //MARK: FONCTION STOP MUSIC
    func stopSound() {
        player?.stop()
        player = nil  //vide le player
    }
}
