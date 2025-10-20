//
//  MoodView.swift
//  Aura
//
//  Created by Samara Lima da Silva on 05/09/2025.
//

import SwiftUI

struct MoodView: View {
    @State private var viewModel = MoodViewModel()
    @State private var sliderIndex: Double = 2
    
    let labels = ["Très Mal", "Mal", "Moyen", "Bien", "Très Bien"]
    
    
    private var currentMood: MoodModel? {
        let name = labels[Int(sliderIndex)]
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
                //MARK: - Skip button
                HStack {
                    Spacer()
                    NavigationLink {
                        //TODO: - temporary, using it to test my protected route
                        DayView(token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWJqZWN0IjoiQ0NGNEY0QjMtRTZFNi00QThGLUEzODItM0QzNTA3NUUzODU3IiwiZXhwaXJhdGlvbiI6MTc2MTI5MzAwMy4yNTAyMzksInVzZXJJRCI6IkNDRjRGNEIzLUU2RTYtNEE4Ri1BMzgyLTNEMzUwNzVFMzg1NyJ9.KjVr-ePRAeouTiZQDgNr9aESQQHtghjqychxqOm9vjI")
                    } label: {
                        Text("skip >")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(.black)
                    }
                }
                .padding(.bottom, 20)
                
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
                NavigationLink {
                    DayConfigView(moodID: currentMood?.id,
                                  moodColorName: currentMood?.color,
                                  //MARK: - temporary, using it to test my protected route
                                  token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWJqZWN0IjoiQ0NGNEY0QjMtRTZFNi00QThGLUEzODItM0QzNTA3NUUzODU3IiwiZXhwaXJhdGlvbiI6MTc2MTI5MzAwMy4yNTAyMzksInVzZXJJRCI6IkNDRjRGNEIzLUU2RTYtNEE4Ri1BMzgyLTNEMzUwNzVFMzg1NyJ9.KjVr-ePRAeouTiZQDgNr9aESQQHtghjqychxqOm9vjI"
                    )
                } label: {
                    Text("Valider")
                        .font(.custom("Lexend-medium", size: 17))
                        .foregroundStyle(.black)
                        .frame(width: 349, height: 48)
                        .background(.white.opacity(0.5))
                        .cornerRadius(25)
                }
                .padding(.top, 40)
                
            }
            .padding(24)
        }
        .toolbar(.hidden, for: .tabBar)
        .task {
            await viewModel.fetchMoods()
        }
    }
}


#Preview {
    MoodView()
}
