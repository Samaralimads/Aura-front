//
//  MoodView.swift
//  Aura
//
//  Created by Samara Lima da Silva on 05/09/2025.
//

import SwiftUI

struct MoodView: View {
    @Environment(AppState.self) private var appState
    
    @State private var viewModel = MoodViewModel()
    @State private var sliderIndex: Double = 2
    
    let labels = ["Très Mal", "Mal", "Moyen", "Bien", "Très Bien"]
    
    private var effectiveToken: String? { appState.token }
    
    private var currentMood: MoodModel? {
        let name = labels[Int(sliderIndex)]
        return viewModel.moods.first { $0.name == name }
    }
    
    private var backgroundColor: Color {
        MoodColors.fromAsset(name: currentMood?.color)
    }
    
    private var imageURL: URL? {
        if let imageName = currentMood?.image {
            return URL(string: "http://127.0.0.1:8080/mood/\(imageName)")
        }
        return nil
    }
    
    var body: some View {
        ZStack {
            
            LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: backgroundColor.opacity(0.95), location: 0.0),
                            .init(color: backgroundColor.opacity(0.75), location: 0.4),
                            .init(color: backgroundColor.opacity(0.55), location: 1.0),
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ).ignoresSafeArea()
            
            FloatingDots(base: .white.opacity(0.55), count: 20)
            
            Image("Vector24")
                .resizable()
                .scaledToFit()
                .frame(height: 314)
                .padding(.bottom, 60)
            Image("Vector25")
                .resizable()
                .scaledToFit()
                .frame(height: 340)
                .padding(.bottom, 60)
            Image("Vector26")
                .resizable()
                .scaledToFit()
                .frame(height: 270)
                .padding(.bottom, 60)
                .opacity(0.5)
            
            
            VStack{

                //MARK: - Title
                Text("Comment allez-vous\naujourd’hui ?")
                    .font(.custom("Lexend-medium", size: 27))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 35)
              
                //MARK: - Mood Image
                
                Spacer()
                
                if let url = imageURL {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .scaledToFit()
                            .frame(width: 173, height: 170)

                    } placeholder: {
                        ProgressView()
                            .frame(height: 220)
                    }
                }
                
                //MARK: - Slider
                
                Spacer()
                
                Text(labels[Int(sliderIndex)])
                    .font(.custom("Lexend-medium", size: 28))
                Slider(value: $sliderIndex, in: 0...4)
                    .accentColor(Color(.white))
                    .padding(.top, 10)

                
                //MARK: - Button
                Button {
                                    appState.humeurPath.append(
                                        HumeurRoute.configureDay(
                                            moodID: currentMood?.id,
                                            moodColorName: currentMood?.color
                                        )
                                    )
                                } label: {
                                    Text("Valider")
                                        .font(.custom("Lexend-medium", size: 17))
                                        .foregroundStyle(.black)
                                        .frame(width: 349, height: 48)
                                        .glassEffect(.regular.interactive())
                                        .cornerRadius(25)
                                }
                                .padding(.top, 40)
                
            }
            .padding(24)
        }
        .task {
            await viewModel.fetchMoods()
            
        }.toolbar(.hidden, for: .tabBar)

    }
}


#Preview {
    MoodView()
    .environment(AppState())
}
