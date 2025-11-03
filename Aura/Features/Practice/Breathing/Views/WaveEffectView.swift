//
//  wave.swift
//  Aura
//
//  Created by alize suchon on 02/10/2025.
//

import SwiftUI

struct WaveEffectView: View {
    
    @State var viewModel : BreathingPlayerViewModel
    @State private var phase: CGFloat = 0
    @State var wavePosition: CGFloat = 0
    var waveStartPosition: CGFloat = 0
    
    @State private var waveTask: Task<Void, Never>?
    
    var body: some View {
        ZStack {
            Color.violetClair
                .ignoresSafeArea()
            
            VStack {
                ZStack {
                    //Wave 1 (loin)
                    Wave(amplitude: 4, frequency: 1, phase: phase)
                        .fill(Color.wave1)
                        .opacity(0.5)
                    
                    //Wave 2
                    Wave(amplitude: 5, frequency: 2, phase: phase)
                        .fill(Color.wave1)
                        .offset(y: 50)
                    
                    //Wave 3
                    Wave(amplitude: 7, frequency: 3, phase: phase)
                        .fill(Color.wave2)
                        .offset(y: 160)
                    
                    //Wave 4 (proche)
                    Wave(amplitude: 25, frequency: 2, phase: phase)
                        .fill(Color.wave3)
                        .offset(y: 260)
                }
                .frame(maxWidth: .infinity)
                .offset(y: wavePosition)
            }
            
            //LUNE
            Image("lune")
                .resizable()
                .scaledToFit()
                .frame(height: 95)
                .offset(x: 80, y: -310)
        }
        .toolbar(.hidden, for: .tabBar)
        
        //Animation continue
        .onAppear {
            withAnimation(.linear(duration: 6).repeatForever(autoreverses: false)){
                phase = .pi * 2
            }
        }
        .onChange(of: viewModel.isPlaying) { oldStatus, newStatus in
            if viewModel.isPlaying{
                startWaveAnim()
            } else {
                waveTask?.cancel()
                waveTask = nil
                if viewModel.isFinished {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        wavePosition = waveStartPosition
                    }
                }
            }
        }
    }
    
    //MARK: - ANIM WAVES FUNCTION
    func startWaveAnim(){
        waveTask = Task {
            while viewModel.isPlaying {
                //INHALE
                withAnimation(.easeInOut(duration: Double(viewModel.inhaleD))) {
                    wavePosition = waveStartPosition - 150
                }
                try? await Task.sleep(for: .seconds(viewModel.inhaleD))
                
                //HOLD
                try? await Task.sleep(for: .seconds(viewModel.holdD))
                
                //EXHALE
                withAnimation(.easeInOut(duration: Double(viewModel.exhaleD))) {
                    wavePosition = waveStartPosition
                }
                try? await Task.sleep(for: .seconds(viewModel.exhaleD))
            }
        }
    }
}

#Preview {
    WaveEffectView(
        viewModel:BreathingPlayerViewModel(
            inhaleD: 4,
            holdD: 1,
            exhaleD: 4,
            nbOfCycles: 6,
            indexOrder : 3,
            audio: "night")
    )
}
