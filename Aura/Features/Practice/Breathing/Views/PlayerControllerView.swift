//
//  PlayerControllerView.swift
//  Aura
//
//  Created by alize suchon on 16/10/2025.
//

import SwiftUI

struct PlayerControllerView: View {
    
    @State var viewModel : BreathingPlayerViewModel
    private let musicManager = MusicManager()
    
    var body: some View {
        //MARK: FIXED TIMER + PLAYER
        VStack{
            //conversion en minutes / secondes
            let minutes : Int = viewModel.timeRemaining / 60
            let seconds : Int = viewModel.timeRemaining % 60
            
            Text(String(format : "%02d:%02d", minutes, seconds))
                .foregroundColor(.white)
                .font(.custom("Lexend-Medium", size: 60))
                .padding(.bottom, 10)
            
            Text(viewModel.cycles[viewModel.indexCycle])
                .foregroundColor(.white)
                .font(.custom("Lexend-Medium", size: 27))
            
            //MARK: PLAYER
            HStack (spacing: 25){
                Button(action: {
                    viewModel.startBreathing()
                    musicManager.playSound(named: viewModel.audio)
                }){
                    ZStack{
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 60, height: 60)
                        Image("Play")
                            .offset(x: 2)
                    }
                    .glassEffect(.regular.interactive())
                }
                Button(action: {
                    viewModel.pauseBreathing()
                    musicManager.pauseSound()
                }){
                    ZStack{
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 60, height: 60)
                        Image("Pause")
                    }
                    .glassEffect(.regular.interactive())
                }
            }
            .padding(.top, 20)
        }
        .padding(.bottom, 60)
        .frame(maxHeight: .infinity, alignment: .bottom)
        .onDisappear {
            viewModel.stopBreathing()
            musicManager.stopSound()
        }
    }
}

