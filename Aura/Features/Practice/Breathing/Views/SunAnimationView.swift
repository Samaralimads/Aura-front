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
    
    @State private var cloudTask: Task<Void, Never>?
    
    var body: some View {
        GeometryReader{ geometry in
            let screenWidth = geometry.size.width
            ZStack(alignment: .center){
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
            .toolbar(.hidden, for: .tabBar)
            .frame(width: geometry.size.width, height: geometry.size.height)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            .onChange(of: viewModel.isPlaying) { oldStatus, newStatus in
                if viewModel.isPlaying {
                    startCloudAnim(screenWidth: screenWidth)
                } else {
                    cloudTask?.cancel()
                    cloudTask = nil
                }
            }
        }
    }
    
    // MARK: - ANIME CLOUDS V2 TASK
    private func startCloudAnim(screenWidth: CGFloat) {
        cloudTask = Task {
            while viewModel.isPlaying {
                //INHALE
                withAnimation(.easeInOut(duration: Double(viewModel.inhaleD))) {
                    clouds[0].x = -screenWidth
                    clouds[1].x = screenWidth
                    clouds[2].x = -screenWidth
                }
                try? await Task.sleep(for: .seconds(viewModel.holdD + viewModel.inhaleD))
                withAnimation(.easeOut(duration: Double(viewModel.exhaleD))){
                    clouds = cloudsArray
                }
                try? await Task.sleep(for: .seconds(viewModel.exhaleD))
                
                if !viewModel.isPlaying{
                    withAnimation(.easeInOut(duration: 1)){
                        clouds[0].x = -screenWidth
                        clouds[1].x = screenWidth
                        clouds[2].x = -screenWidth
                    }
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
            indexOrder : 3,
            audio: "night")
    )
}
