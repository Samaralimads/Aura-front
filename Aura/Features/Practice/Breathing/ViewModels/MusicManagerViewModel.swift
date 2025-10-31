//
//  MusicManagerModelView.swift
//  Aura
//
//  Created by alize suchon on 02/10/2025.
//

import AVFoundation

class MusicManager {
    
    private var player: AVPlayer?
    
    //MARK: FONCTION PLAY MUSIC
    func playSound(named url: String) {
        guard let url = URL(string: url) else {
            print("ERROR: URL invalid.")
            return
        }
        player?.pause()
        player = AVPlayer(url: url)
        player?.play()
    }
    
    func pauseSound() {
        player?.pause()
    }
    
    //MARK: FONCTION STOP MUSIC
    func stopSound() {
        player?.pause()
        player = nil  //vide le player
    }
}
