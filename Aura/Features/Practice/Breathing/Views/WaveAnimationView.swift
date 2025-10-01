//
//  Breathing1View.swift
//  Aura
//
//  Created by alize suchon on 26/09/2025.
//

import SwiftUI

struct WaveAnimationView: View {
    
    @State private var horizontalOffset: CGFloat = 0
    @State private var verticalOffset: CGFloat = 0
    @State private var isInhaling = true
    
    //temps 4-4-4-4
    let durationInhale = 4.0
    let durationExhale = 4.0
    
    var body: some View {
        
        VStack{
            Image("lune")
                .resizable()
                .scaledToFit()
                .frame(height: 95)
                .offset(x: 70)
            ZStack{
                Image("wave1")
                    .resizable()
                    .scaledToFill()
                    .offset(x: horizontalOffset, y: verticalOffset)
                    .animation(.linear(duration: 4).repeatForever(autoreverses: false), value: horizontalOffset)
                
                Image("wave2")
                    .resizable()
                    .scaledToFill()
                    .offset(x: horizontalOffset / 2, y: verticalOffset)
                    .animation(.linear(duration: 6).repeatForever(autoreverses: false), value: horizontalOffset)
                
                Image("wave3")
                    .resizable()
                    .scaledToFill()
                    .offset(x: horizontalOffset / 3, y: verticalOffset)
                    .animation(.linear(duration: 8).repeatForever(autoreverses: false), value: horizontalOffset)
            
            }
            .onAppear {
                // Animation horizontale
                horizontalOffset = -100
                
                // Animation verticale synchronisée avec respiration
                Timer.scheduledTimer(withTimeInterval: durationInhale + durationExhale, repeats: true) { _ in
                    withAnimation(.easeInOut(duration: durationInhale)) {
                        verticalOffset = -10 // mer descend (inhaler)
                        isInhaling = true
                    }
                }
                
            }
        }
        .background(.violetClair)
    }
}
#Preview {
    WaveAnimationView()
}
