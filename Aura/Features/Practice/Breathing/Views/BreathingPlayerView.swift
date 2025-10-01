//
//  BreathingPlayerView.swift
//  Aura
//
//  Created by alize suchon on 26/09/2025.
//

import SwiftUI

struct BreathingPlayerView: View {
    
    @State var viewModel = BreathingPlayerViewModel(inhaleD: 4, holdD: 0, exhaleD: 4)
    
    @State private var timer : Int = 0
    public var body: some View {
        
        //Integration animation
        ZStack{
            WaveAnimationView()
                .ignoresSafeArea()
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
                
                HStack (spacing: 25){
                    Button(action: {
                        viewModel.start() }){
                            ZStack{
                                Circle()
                                    .frame(width: 60, height: 60)
                                Image("Play")
                                    .offset(x: 2)
                            }
                            .glassEffect(.regular.interactive())
                        }
                    Button(action: {
                        viewModel.stop() }){
                            ZStack{
                                Circle()
                                    .frame(width: 60, height: 60)
                                Image("Pause")
                            }
                            .glassEffect(.regular.interactive())
                        }
                }
                .padding(.top, 20)
            }
            
        }
    }
}
#Preview {
    BreathingPlayerView(
        viewModel: BreathingPlayerViewModel(inhaleD: 4, holdD: 0, exhaleD: 4)
    )
}
