//
//  MoonAnimationView.swift
//  Aura
//
//  Created by alize suchon on 26/09/2025.
//

import SwiftUI

struct MoonAnimationView: View {
    
    @State var viewModel : BreathingPlayerViewModel
    @State private var waveScale: CGFloat = 0.9
    @State private var waveOpacity: Double = 0.5
    @State private var moonScale: CGFloat = 0.8
    @State private var rayonsScale: CGFloat = 0.8
    
    @State var moonTask: Task<Void, Never>?

    let baseSizes: [CGFloat] = [170, 225, 275]

    var body: some View {
        ZStack {
            StarsAnimView()
            ZStack {
                
                //MOON WAVES
                ForEach(0..<2) { i in
                    Circle()
                        .foregroundColor(.moon)
                        .frame(width: baseSizes[i + 1], height: baseSizes[i + 1])
                        .scaleEffect(rayonsScale)
                        .scaleEffect(waveScale)
                        .opacity(waveOpacity - Double(i) * 0.1)
                }
                    //MOON CENTER
                    Circle()
                        .foregroundColor(.moon)
                        .frame(width: baseSizes[0], height: baseSizes[0])
                        .scaleEffect(moonScale)
            }
            .offset(y: -100)
            
            //Animation continue
            .onAppear {
                withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)){
                    waveScale = 1.1
                }
            }
            .onChange(of: viewModel.isPlaying) { oldStatus, newStatus in
                if viewModel.isPlaying {
                   moonAnimStart()
                } else {
                    moonTask?.cancel()
                    moonTask = nil
                    if viewModel.isFinished{
                        moonScale = 0.8
                        rayonsScale = moonScale
                    }
                    
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }
    
    //MARK: - MOON ANIM
    func moonAnimStart() {
        
        moonTask?.cancel()
        moonTask = Task {
            while viewModel.isPlaying {
                withAnimation(.easeInOut(duration: Double(2))) {
                    //INHALE
                    moonScale = 1.2
                    rayonsScale = moonScale
                }
                try? await Task.sleep(for: .seconds(viewModel.inhaleD))

                //HOLD
                try? await Task.sleep(for: .seconds(viewModel.holdD))
                //EXHALE
                withAnimation(Animation.easeInOut(duration: Double(2))) {
                    moonScale = 0.8
                    rayonsScale = moonScale
                }
                try? await Task.sleep(for: .seconds(viewModel.exhaleD))
            }
        }
    }
}

#Preview {
    MoonAnimationView(
        viewModel:BreathingPlayerViewModel(
            inhaleD: 4,
            holdD: 1,
            exhaleD: 4,
            nbOfCycles: 6,
            indexOrder : 3,
            audio: "night")
    )
}
