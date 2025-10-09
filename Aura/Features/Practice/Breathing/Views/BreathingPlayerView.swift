//
//  BreathingPlayerView.swift
//  Aura
//
//  Created by alize suchon on 26/09/2025.
//

import SwiftUI

struct BreathingPlayerView: View {
    
    private let musicManager = MusicManager()
    
    @State var viewModel : BreathingPlayerViewModel
    @State private var timer : Int = 0
    public var body: some View {
        
        //Intégration animation
        ZStack{
            if viewModel.indexOrder == 1{
                WaveEffectView(
                    inhaleD: viewModel.inhaleD,
                    holdD: viewModel.holdD,
                    exhaleD: viewModel.exhaleD,
                    nbOfCycles: viewModel.nbOfCycles,
                   // scale: 
                )
                    .ignoresSafeArea()
            }
            else if viewModel.indexOrder == 2{
                MontainAnimationView()
                    .ignoresSafeArea()
            }
            else if viewModel.indexOrder == 3{
                SunAnimationView()
                    .ignoresSafeArea()
            }
            else {
                MoonAnimationView(viewModel: viewModel)
                
                    .ignoresSafeArea()
            }
            
            //MARK: FIXED TIMER + PLAYER
            VStack{
               // Spacer()
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
                        musicManager.playSound(named: "night")
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
                        viewModel.stopBreathing()
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
        }
        .onDisappear {
            viewModel.stopBreathing()
            musicManager.stopSound()
        }
    }
}

#Preview {
    BreathingPlayerView(
        viewModel: BreathingPlayerViewModel(
            inhaleD: 4,
            holdD: 1,
            exhaleD: 4,
            nbOfCycles: 6,
            indexOrder : 3
        )
    )
}
