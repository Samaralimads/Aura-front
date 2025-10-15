//
//  MontainAnimationView.swift
//  Aura
//
//  Created by alize suchon on 26/09/2025.
//

import SwiftUI

struct MontainAnimationView: View {
    
    @State var viewModel : BreathingPlayerViewModel
    @State var currentColor: Color = Color.violetF
    @State private var sunsetTask: Task<Void, Never>?
    @State var sunY: CGFloat = 200
    @State var sunX: CGFloat = 0 //pas uitlisée pour le moment
    
    @State var cloud1X: CGFloat = -200
    @State var cloud2X: CGFloat = 200
        
    var body: some View {
        ZStack{
           currentColor
                .ignoresSafeArea()
            
            //SUN
            Circle()
                .fill(Color.jaune)
                .frame(width: 100, height: 100)
                .offset(x: 0, y: sunY)
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
            }
        }
    }
    func StartSunsetAnim() {
        sunsetTask = Task {
            while viewModel.isPlaying {
                withAnimation(.easeInOut(duration: Double(viewModel.inhaleD))) {
                    // Inhale
                    currentColor = .wave3
                    sunY = -220
                }
                try? await Task.sleep(for: .seconds(viewModel.inhaleD))
                withAnimation(.easeInOut(duration: Double(viewModel.holdD + viewModel.exhaleD))) {
                    // hold + exhale
                    currentColor = .violetF
                    sunY = 300
                }
             try? await Task.sleep(for: .seconds(viewModel.exhaleD))

            }
        }
    }
}

#Preview {
    MontainAnimationView(viewModel:BreathingPlayerViewModel(
        inhaleD: 4,
        holdD: 1,
        exhaleD: 4,
        nbOfCycles: 6,
        indexOrder : 3)
    )
}
