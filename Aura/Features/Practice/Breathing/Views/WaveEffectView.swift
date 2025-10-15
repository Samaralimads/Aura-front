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
                stopWaveAnimation()
            }
        }
    }
    
    //MARK: - ANIM WAVES
    func startWaveAnim() {
        waveTask = Task {
            while viewModel.isPlaying {
                //INHALE
                await animateWave(to: waveStartPosition - 150, duration: viewModel.inhaleD)
                
                //HOLD
                try? await Task.sleep(for: .seconds(viewModel.holdD))
                
                //EXHALE
                await animateWave(to: waveStartPosition, duration: viewModel.exhaleD)
            }
        }
    }
    
    //MARK: - STOP ANIM WAVES
    func stopWaveAnimation() {
        waveTask?.cancel()
        waveTask = nil
    }
    
    func animateWave(to position: CGFloat, duration: Int) async {
        await MainActor.run {
            withAnimation(.easeInOut(duration: Double(duration))) {
                wavePosition = position
            }
        }
        try? await Task.sleep(for: .seconds(duration))
    }
    
}//end view

#Preview {
    WaveEffectView(
        viewModel:BreathingPlayerViewModel(
            inhaleD: 4,
            holdD: 1,
            exhaleD: 4,
            nbOfCycles: 6,
            indexOrder : 3)
    )
}
