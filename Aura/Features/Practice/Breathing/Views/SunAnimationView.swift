//
//  SunAnimationView.swift
//  Aura
//
//  Created by alize suchon on 26/09/2025.
//

import SwiftUI

struct SunAnimationView: View {
    
    @State var viewModel : BreathingPlayerViewModel
    @State private var waveScale: CGFloat = 0.9
    @State private var clouds = cloudsArray
    
    var body: some View {
        ZStack {
            
            LinearGradient(
                colors: [Color.naranja, Color.orangeClair],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            //SUN
            Circle()
                .fill(Color.jaune)
                .frame(width: 150, height: 150)
                .offset(x: 0, y: -150)
            Circle()
                .fill(Color.jaune)
                .opacity(0.5)
                .frame(width: 210, height: 210)
                .scaleEffect(waveScale)
                .offset(x: 0, y: -150)
                .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: waveScale)
                .onAppear {
                    waveScale = 1
                }
            //Placement des nuages
            ForEach(clouds){ cloud in
                Image("nuage")
                    .resizable()
                    .frame(width: cloud.width, height: cloud.height)
                    .offset(x: cloud.x, y: cloud.y)
            }
            
            //NUAGE FIXE BAS
            Image("nuageBas")
                .resizable()
                .frame(width: 441, height: 166)
                .offset(x: 0, y: 360)
        }
        .onAppear {
            clouds = cloudsArray
        }
        .onChange(of: viewModel.isPlaying) { oldStatus, newStatus in
            if viewModel.isPlaying {
                startCloudAnim()
            }
        }
    }
    
    // MARK: - ANIME CLOUDS
    private func startCloudAnim() {
        //Inspire
        withAnimation(.easeInOut(duration: Double(viewModel.inhaleD))) {
            clouds[0].x = -UIScreen.main.bounds.width
            clouds[1].x = UIScreen.main.bounds.width
            clouds[2].x = -UIScreen.main.bounds.width
        }
        // Hold + Exhale
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(viewModel.exhaleD + viewModel.holdD)) {
            guard self.viewModel.isPlaying else { return }
            withAnimation(.easeOut(duration: 3)) {
                clouds = cloudsArray
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(viewModel.exhaleD)) {
                if viewModel.isPlaying {
                    guard self.viewModel.isPlaying else { return }
                    startCloudAnim()
                }
            }
        }
    }
}

#Preview {
    SunAnimationView(
        viewModel:BreathingPlayerViewModel(
            inhaleD: 4,
            holdD: 1,
            exhaleD: 4,
            nbOfCycles: 6,
            indexOrder : 3)
    )
}
