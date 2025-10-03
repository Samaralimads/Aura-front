//
//  MoodView.swift
//  Aura
//
//  Created by Samara Lima da Silva on 05/09/2025.
//

import SwiftUI

struct MoodView: View {
    @State private var viewModel = MoodViewModel()
    @State private var index: Double = 2
    
    let labels = ["Très Mal", "Mal", "Moyen", "Bien", "Très Bien"]
    
    
    private var currentMood: MoodModel? {
        let name = labels[Int(index)]
        return viewModel.moods.first { $0.name == name }
    }
    
    private var backgroundColor: Color {
        if let colorName = currentMood?.color {
            return Color(colorName)
        } else {
            return Color.gray.opacity(0.15)
        }
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
            AuraRings(base: .white)
                
            
            VStack{
                //MARK: - Skip button
                HStack {
                    Spacer()
                    //TODO: - temporary, using it to test my protected route
                    NavigationLink {
                        DayView(token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHBpcmF0aW9uIjoxNzU5NTA0NDc5LjU4NTk2LCJpZCI6IjZBMjJCMTJELTkxMTYtNDc4Ri1BNTU2LUVDM0JFQkJCODEyQiJ9.8KiOHg7IShtj-Db0QTsODPZXFSeCWGV4AbTdGbvfihc")
                    } label: {
                        Text("skip >")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(.black)
                    }
                }
                .padding(.bottom, 50)
                
                //MARK: - Title
                Text("Comment allez-vous\naujourd’hui ?")
                    .font(.custom("Lexend-medium", size: 27))
                    .multilineTextAlignment(.center)
                
                Spacer()
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
                    .padding(.bottom, 24)
                }
                
                //MARK: - Slider
                
                Spacer()
                Text(labels[Int(index)])
                    .font(.custom("Lexend-medium", size: 28))
                    .padding(.bottom, 30)
                
                Slider(value: $index, in: 0...4, step: 0.5)
                    .accentColor(Color(.white))
                
                
                
                //MARK: - Button
                NavigationLink {
                    DayConfigView(moodID: currentMood?.id,
                                  moodColorName: currentMood?.color,
                                  //MARK: - temporary, using it to test my protected route
                                  token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHBpcmF0aW9uIjoxNzU5NTA0NDc5LjU4NTk2LCJpZCI6IjZBMjJCMTJELTkxMTYtNDc4Ri1BNTU2LUVDM0JFQkJCODEyQiJ9.8KiOHg7IShtj-Db0QTsODPZXFSeCWGV4AbTdGbvfihc"
                    )
                } label: {
                    Text("Valider")
                        .font(.custom("Lexend-medium", size: 17))
                        .foregroundStyle(.black)
                        .frame(width: 349, height: 48)
                        .background(.white.opacity(0.5))
                        .cornerRadius(25)
                }
                .padding(.top, 60)
                
            }
            .padding(24)
        }
        .task {
            await viewModel.fetchMoods()
        }
    }
}

#Preview {
    MoodView()
}
