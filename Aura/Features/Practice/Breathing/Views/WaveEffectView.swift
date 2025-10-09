//
//  wave.swift
//  Aura
//
//  Created by alize suchon on 02/10/2025.
//

import SwiftUI

struct WaveEffectView: View {
    
    @State private var phase: CGFloat = 0
    var inhaleD: Int
    var holdD: Int
    var exhaleD: Int
    var nbOfCycles: Int
    
    let waveLift: CGFloat = -120
    
    var body: some View {
          ZStack {
              Color.violetClair
                  .ignoresSafeArea()
              
              VStack {
                  Spacer()
                  
                  ZStack {
                      //Wave 1 (loin)
                      Wave(amplitude: 4, frequency: 1, phase: phase, variationAmplitude: true)
                          .fill(Color.wave1)
                          .opacity(0.5)
                          .frame(height: 700)
                      
                      //Wave 2
                      Wave(amplitude: 5, frequency: 2, phase: phase, variationAmplitude: true)
                          .fill(Color.wave1)
                          .frame(height: 700)
                          .offset(y: 50)
                      
                      //Wave 3
                      Wave(amplitude: 7, frequency: 3, phase: phase, variationAmplitude: true)
                          .fill(Color.wave2)
                          .frame(height: 700)
                          .offset(y: 160)
                      
                      //Wave 4 (plus proche)
                      Wave(amplitude: 25, frequency: 2, phase: phase, variationAmplitude: true)
                          .fill(Color.wave3)
                          .frame(height: 700)
                          .offset(y: 260)
                  }
                  .frame(maxWidth: .infinity)
                  .offset(y: waveLift)
              }
              
              //LUNE
              Image("lune")
                  .resizable()
                  .scaledToFit()
                  .frame(height: 95)
                  .offset(x: 80, y: -310)
          }
          .onAppear {
              withAnimation(.linear(duration: 6).repeatForever(autoreverses: false)) {
                  phase = .pi * 2
              }
          }
      }
  }

#Preview {
    WaveEffectView(inhaleD:4 , holdD:4 , exhaleD: 4, nbOfCycles: 5)
}
