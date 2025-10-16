//
//  SunsetEffect.swift
//  Aura
//
//  Created by alize suchon on 15/10/2025.
//

import SwiftUI

struct SunsetEffectView: View {
    
    @State var viewModel : BreathingPlayerViewModel
    @State var currentColor: Color = Color.violetF
    @State private var sunsetTask: Task<Void, Never>?
    @State var sunY: CGFloat = 210
    @State var sunX: CGFloat =  -150
    @State private var waveScale: CGFloat = 0.9
    
    @State var cloud1X: CGFloat = -200
    @State var cloud2X: CGFloat = 200
    
    var body: some View {
        ZStack{
            currentColor
                .ignoresSafeArea()
            
            //SUN
            ZStack{
                Circle()
                    .fill(Color.jaune)
                    .frame(width: 100, height: 100)
                Circle()
                    .fill(Color.jaune.opacity(0.5))
                    .frame(width: 130, height: 130)
                    .scaleEffect(waveScale)
            }
            .offset(x: sunX, y: sunY)
            .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: waveScale)
            .onAppear {
                waveScale = 1
            }
            
            //NUAGE 1
            Image("nuage")
                .resizable()
                .frame(width: 95, height: 39)
                .offset(x: cloud1X, y: -360)
            
            //NUAGE 2
            Image("nuage")
                .resizable()
                .frame(width: 141, height: 58)
                .offset(x: cloud2X, y: -200)
            
            //Animation continue nuages
                .onAppear {
                    withAnimation(.linear(duration: 15).repeatForever(autoreverses: true)){
                        cloud2X = -UIScreen.main.bounds.width
                        cloud1X = UIScreen.main.bounds.width
                    }
                }
            
            Image("montain")
                .resizable()
                .frame(maxWidth: .infinity)
                .ignoresSafeArea(edges: .bottom)
            
        }
        .onChange(of: viewModel.isPlaying) { oldStatus, newStatus in
            if viewModel.isPlaying {
                StartSunsetAnim()
            } else {
                sunsetTask?.cancel()
                sunsetTask = nil
                if viewModel.isFinished {
                    withAnimation(.easeInOut(duration: 1)) {
                        currentColor = .violetF
                        sunY = 200
                        sunX = -150
                    }
                }
            }
        }
    }
    func StartSunsetAnim() {
        sunsetTask = Task {
            while viewModel.isPlaying {
                withAnimation(.easeInOut(duration: Double(viewModel.inhaleD + viewModel.holdD))) {
                    // Inhale
                    currentColor = .fondClair//.wave3
                    sunY = -220
                    sunX = -150
                }
                
                try? await Task.sleep(for: .seconds(viewModel.holdD))
                withAnimation(.easeInOut(duration: Double(1))) {
                    // hold
                    currentColor = .fondClair//.wave3
                    sunY = -220
                    sunX = 0
                }
                
                try? await Task.sleep(for: .seconds(viewModel.inhaleD))
                withAnimation(.easeInOut(duration: Double( viewModel.exhaleD))) {
                    // exhale
                    currentColor = .violetF
                    sunY = 300
                    sunX = 550
                }
                try? await Task.sleep(for: .seconds(viewModel.exhaleD))
                sunY = 210
                sunX = -150
            }
        }
    }
}


#Preview {
    SunsetEffectView(viewModel:BreathingPlayerViewModel(
        inhaleD: 4,
        holdD: 1,
        exhaleD: 4,
        nbOfCycles: 6,
        indexOrder : 3,
        audio: "night")
    )
}
