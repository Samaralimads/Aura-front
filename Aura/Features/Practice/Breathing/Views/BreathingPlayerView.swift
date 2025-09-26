//
//  BreathingPlayerView.swift
//  Aura
//
//  Created by alize suchon on 26/09/2025.
//

import SwiftUI

struct BreathingPlayerView: View {
    
    @State var viewModel = BreathingPlayerViewModel(duration: 50)
    var animation : AnimationType

    @State private var timer : Int = 0
    public var body: some View {
        VStack{
            Text("00:\(viewModel.timeRemaining)")
                .foregroundColor(.black)
                .font(.custom("Lexend-Medium", size: 60))
        }

        HStack (spacing: 15){
            Button(action: {
                viewModel.start() }){
                    Image("Play")
                }
            Button(action: {
                viewModel.stop() }){
                    Image("Pause")
                }
        }
    }
}

#Preview {
    BreathingPlayerView(
           viewModel: BreathingPlayerViewModel(duration: 50),
           animation: .wave
       )
}
