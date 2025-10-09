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

    let baseSizes: [CGFloat] = [182, 230, 274]

    var body: some View {
        ZStack {
            StarsAnimView()
            ZStack {
                ForEach(0..<2) { i in
                    Circle()
                        .foregroundColor(.moon)
                        .frame(width: baseSizes[i + 1], height: baseSizes[i + 1])
                        .scaleEffect(waveScale)
                        .scaleEffect(viewModel.scale * waveScale)
                        .opacity(waveOpacity - Double(i) * 0.1)
                               }
                               
                               Circle()
                                   .foregroundColor(.moon)
                                   .frame(width: baseSizes[0], height: baseSizes[0])
                                   .scaleEffect(viewModel.scale)
                                   .opacity(0.8)
            }
            .offset(y: -100)
            
            //Animation continue
            .onAppear {
                withAnimation(.easeInOut(duration: 5).repeatForever(autoreverses: true)){
                    waveScale = 1.0
                }
            }
            
            //Tracker variable isPlaying
            .onChange(of: viewModel.isPlaying) { oldStatus, newStatus in
                if viewModel.isPlaying {
                    viewModel.MoonAnimStart()
                }
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
            indexOrder : 3))
}
